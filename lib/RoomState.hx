package lib;

import sk.thenet.stream.bmp.Bresenham;

class RoomState {
  static var ROOM_ID:Int = 0;
  static inline var POV_STRENGTH:Float = 100;
  
  public var id:Int;
  public var visited:Bool = false;
  public var width:Int;
  public var height:Int;
  public var w2:Int;
  public var h2:Int;
  public var wh:Int;
  public var wh4:Int;
  public var mask:Vector<Bool>;
  public var walls:Vector<WallType>;
  public var pov:Vector<Int>;
  public var entities:Array<Entity> = [];
  public var type:RoomType;
  public var title:String;
  public var boundary:Vector<Point2DI>;
  public var tapes:Array<Tape> = [];
  public var portals:Array<Portal> = [];
  public var visuals:Array<RoomVisual> = [];
  public var redrawVisuals:Bool = false;
  public var itemSelected:Item = null;
  
  public function new(type:RoomType, width:Int, height:Int) {
    this.type = type;
    id = ROOM_ID++;
    this.width = width;
    this.height = height;
    updateMask();
  }
  
  public function updateMask():Void {
    wh = width * height;
    w2 = width * 2;
    h2 = height * 2;
    wh4 = w2 * h2;
    mask = Vector.fromArrayCopy([ for (i in 0...wh) 1 ].map(n -> n > 0));
    if (type == CharSheet) {
      mask[7 + 9 * width] = false;
    }
    walls = Vector.fromArrayCopy([ for (y in 0...h2) for (x in 0...w2)
        //x == 0 || x == w2 - 1 || y == 0 || y == height * 2 - 1 || FM.prng.nextBool() ? WallType.None : WallType.Solid
        x == 1 || x == w2 - 2 || y == 1 || y == h2 - 2 ? WallType.Invisible : WallType.None
      ]);
    pov = Vector.fromArrayCopy([ for (i in 0...wh4) -1 ]);
    boundary = new Vector<Point2DI>(w2 + h2 - 4);
    var bvi = 0;
    for (x in 0...w2) {
      boundary[bvi++] = new Point2DI(x, 0);
      boundary[bvi++] = new Point2DI(x, h2 - 1);
    }
    for (y in 1...h2 - 1) {
      boundary[bvi++] = new Point2DI(0, y);
      boundary[bvi++] = new Point2DI(w2 - 1, y);
    }
  }
  
  public function fix():Void {
    for (e in entities) e.room = this;
  }
  
  function charSheet():Void {
    var rpg = Main.g.state.rpg;
    if (rpg != null && !rpg.changed) return;
    var player = Main.g.state.player;
    var invWeight = 0;
    for (i in rpg.inventory) invWeight += i.weight;
    rpg.overburdened = invWeight > rpg.capacity;
    rpg.changed = false;
    visuals = [];
    visuals.push(lib.Text.centred("Character factbook", 120, 20));
    var cy = 36;
    for (c in [
         {title: "Health/Max", value: '${player.health}/${rpg.maxHealth}'}
        ,{title: "Gold", value: "" + rpg.gold}
        ,{title: "Strength/Capacity", value: '${rpg.strength}/${rpg.capacity}lb'}
        ,{title: "Speed/Atk rate", value: '${rpg.speed}/${rpg.rate}'}
        ,{title: "Defense", value: '${rpg.defense}'}
        ,{title: [
             {val: rpg.overburdened, text: "Overburdened"}
            ,{val: player.poison > 0, text: "Poisoned"}
            ,{val: rpg.toxic > 5, text: "Toxic"}
            ,{val: player.stun > 0, text: "Stunned"}
          ].filter(v -> v.val).map(v -> v.text).join(", "), value: ""}
      ]) {
      visuals.push(Text(Text.t(Small) + c.title, 20, cy + 2));
      visuals.push(Text(c.value, 160, cy));
      cy += 16;
    }
    visuals.push(Text(Text.t(Small3) + "< Press C to\n  continue", 144, 136));
    visuals.push(lib.Text.centred('Inventory (${invWeight}lb)', 120, 172));
    visuals.push(Fold(16, 188, 208));
    var cy = 188 + 16;
    height = 16;
    if (rpg.inventory.indexOf(itemSelected) == -1) itemSelected = null;
    for (i in rpg.inventory) {
      visuals.push(JustifyFont(
           (i.equipped ? "* " : "") + i.name
          ,i == itemSelected ? 24 : 20, cy + 2, 202, i == itemSelected ? Small3 : Small
        ));
      cy += 32;
      height += 2;
    }
    visuals.push(Fold(16, cy, 208)); cy += 16;
    if (itemSelected == null) {
      visuals.push(lib.Text.centred(Text.t(Small3) + "Click to select item above", 120, cy));
    } else {
      visuals.push(lib.Text.centred(Text.t(Small) + "Drop item", 120, cy)); cy += 16;
      visuals.push(lib.Text.centred(Text.t(Small) + itemSelected.action, 120, cy)); cy += 16;
      visuals.push(Text(Text.t(Small) + "Value: " + itemSelected.price + " GP", 20, cy)); cy += 16; height++;
      switch (itemSelected.type) {
        case Weapon(dmg, rate, stun, poison):
        visuals.push(Text(Text.t(Small) + "Weapon", 20, cy)); cy += 16; height++;
        visuals.push(Text(Text.t(Small) + "Damage: " + dmg, 40, cy)); cy += 16; height++;
        if (stun != 0) visuals.push(Text(Text.t(Small) + "Stun: " + stun + Text.t(Regular) + "%", 40, cy)); cy += 16; height++;
        if (poison != 0) visuals.push(Text(Text.t(Small) + "Poison: " + stun + Text.t(Regular) + "%", 40, cy)); cy += 16; height++;
        case Armour(piece, def, thorns):
        visuals.push(Text(Text.t(Small) + "Armour (" + Item.itemTypeString(itemSelected.type).substr(7) + ")", 20, cy)); cy += 16; height++;
        visuals.push(Text(Text.t(Small) + "Defense: " + def, 40, cy)); cy += 16; height++;
        if (thorns != 0) visuals.push(Text(Text.t(Small) + "Thorns (damage reflect): " + thorns + Text.t(Regular) + "%", 40, cy)); cy += 16; height++;
        case Food(heal, toxic, poison):
        visuals.push(Text(Text.t(Small) + "Food", 20, cy)); cy += 16; height++;
        visuals.push(Text(Text.t(Small) + "Heals: " + heal + " HP", 40, cy)); cy += 16; height++;
        if (toxic != 0) visuals.push(Text(Text.t(Small) + "Looks toxic", 40, cy)); cy += 16; height++;
        if (poison != 0) visuals.push(Text(Text.t(Small) + "May be poisoned", 40, cy)); cy += 16; height++;
        case _:
      }
      height++;
    }
    updateMask();
    redrawVisuals = true;
  }
  
  public function add(e:Entity):Void {
    entities.push(e);
    e.room = this;
  }
  
  public function tick(state:GameState) {
    if (type == CharSheet) {
      charSheet();
    }
    for (e in entities) e.tick(state);
    for (i in 0...wh4) if (pov[i] > 0) pov[i]--;
  }
  
  public function revealRect(x1:Int, y1:Int, x2:Int, y2:Int):Void {
    x1 = x1.maxI(0);
    y1 = y1.maxI(0);
    x2 = x2.minI(w2 - 1);
    y2 = y2.minI(h2 - 1);
    for (y in y1...y2 + 1) for (x in x1...x2 + 1) {
      pov[indexTile(x, y)] = POV_STRENGTH;
    }
  }
  
  public function wallRect(rect:Array<WallType>, sx:Int, sy:Int, w:Int, h:Int):Void {
    var ri = 0;
    for (y in sy...(sy + h)) for (x in sx...(sx + w)) {
      walls[indexTile(x, y)] = rect[ri++];
    }
  }
  
  public inline function indexTile(x:Int, y:Int):Int {
    return x + y * w2;
  }
  
  public function portWide(s2:RoomState, x:Int, length:Int, y1:Int, y2:Int, s1h:Bool):Void {
    for (i in 0...length) {
         portals.push({to: s2,   fx: x + i, fy: y1, tx: x + i, ty: y2 + (s1h ? 1 : -1)});
      s2.portals.push({to: this, fx: x + i, fy: y2, tx: x + i, ty: y1 + (s1h ? -1 : 1)});
    }
  }
  
  public function portHigh(s2:RoomState, y:Int, length:Int, x1:Int, x2:Int, s1l:Bool):Void {
    for (i in 0...length) {
         portals.push({to: s2,   fy: y + i, fx: x1, ty: y + i, tx: x2 + (s1l ? 1 : -1)});
      s2.portals.push({to: this, fy: y + i, fx: x2, ty: y + i, tx: x1 + (s1l ? -1 : 1)});
    }
  }
  
  public function vision(px:Int, py:Int, mx:Int, my:Int) {
    if (type == CharSheet) {
      var rpg = Main.g.state.rpg;
      if (mx.withinI(20, 220)) {
        var cy = 188 + 16;
        for (i in rpg.inventory) {
          if (my.withinI(cy, cy + 32)) {
            if (itemSelected == i) itemSelected = null;
            else itemSelected = i;
            rpg.changed = true;
            return;
          }
          cy += 32;
        }
        cy += 16;
        if (itemSelected != null) {
          for (a in [
               itemSelected.drop
              ,itemSelected.doAction
            ]) {
            if (my.withinI(cy, cy + 16)) {
              a();
              break;
            }
            cy += 16;
          }
        }
      }
      return;
    }
    var from = new Point2DI(px, py);
    var angle = Math.atan2(my - py * 8 + 4, mx - px * 8 + 4);
    var c1 = new Point2DF(Math.cos(angle + Math.PI / 4), Math.sin(angle + Math.PI / 4));
    var c2 = c1.normalC();
    for (ray in boundary) {
      var power = 1.0;
      var rp = new Point2DF(ray.x - px, ray.y - py);
      if (rp.dot(c1) < 0 || rp.dot(c2) < 0) continue;
      for (pt in new Bresenham(from, ray)) {
        var mi = indexTile(pt.x, pt.y);
        pov[mi] += (power * POV_STRENGTH).floor();
        switch (walls[mi]) {
          case Solid: power -= 1;
          case _:
        }
        if (power < 0.001) break;
      }
    }
  }
}
