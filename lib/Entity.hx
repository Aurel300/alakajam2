package lib;

class Entity {
  public var room:RoomState;
  public var x:Int;
  public var y:Int;
  public var type:EntityType;
  public var povType:PovType;
  public var pov:Int = 0;
  public var health:Int = 0;
  public var stun:Int = 0;
  public var poison:Int = 0;
  
  public function new(type:EntityType, povType:PovType) {
    this.type = type;
    this.povType = povType;
  }
  
  public function tick(state:GameState):Void {
    if (health > 0) {
      if (stun > 0) stun--;
      if (poison > 0) {
        if (FM.prng.nextMod(30) < poison) {
          health = (health - FM.prng.nextMod(poison - 1) - 1).maxI(1);
          poison--;
        }
      }
    }
    pov = pov.maxI(room.pov[room.indexTile(x, y)]);
    if (pov > 0) pov--;
  }
  
  public function pickUpItem(i:Item):Bool {
    return false;
  }
  
  public function pickUpGold(g:Int):Bool {
    return false;
  }
  
  public function print(str:Array<Array<String>>, pov:Int):Void {
    
  }
  
  public function hurt(by:Entity, attack:Int, stun:Int, poison:Int):Bool {
    var nh = health - attack;
    if (nh <= 0) {
      if (FM.prng.nextMod(2) == 0) {
        health = 1;
      } else {
        health = 0;
        remove();
        return true;
      }
    }
    health = nh;
    this.stun += stun;
    this.poison += poison;
    return false;
  }
  
  public function remove():Void {
    room.entities.remove(this);
  }
  
  public function attack(other:Entity):Void {
    
  }
  
  public function moveTo(to:RoomState, tx:Int, ty:Int):Void {
    remove();
    room = to;
    room.entities.push(this);
    x = tx;
    y = ty;
  }
  
  public inline function walkOrtho(ox:Int, oy:Int):Bool {
    return walk(ox, ox != 0 ? 0 : oy);
  }
  
  public function walk(ox:Int, oy:Int):Bool {
    if (ox == 0 && oy == 0) return false;
    var nx = x + ox;
    var ny = y + oy;
    if (!nx.withinI(0, room.w2 - 1) || !ny.withinI(0, room.h2 - 1)) return false;
    for (p in room.portals) {
      if (nx == p.fx && ny == p.fy) {
        moveTo(p.to, p.tx, p.ty);
        return true;
      }
    }
    for (e in room.entities) {
      if (e == this) continue;
      if (e.x == nx && e.y == ny) {
        switch (e.type) {
          case ItemDrop:
          var pickedUp = pickUpItem((cast e:ItemDrop).item);
          if (pickedUp) e.remove();
          else return false;
          case GoldDrop:
          var pickedUp = pickUpGold((cast e:GoldDrop).gold);
          if (pickedUp) e.remove();
          else return false;
          case Enemy if (type == Player):
          attack(e);
          return false;
          case Player if (type == Enemy):
          attack(e);
          return false;
          case _:
          return false;
        }
      }
    }
    switch (room.walls[room.indexTile(nx, ny)]) {
      case None:
      case Trigger(action): action(this);
      case _: return false;
    }
    x = nx;
    y = ny;
    return true;
  }
  
  public inline function put(str:Array<Array<String>>, x:Int, y:Int, c:String):Void {
    if (y.withinA(str) && x.withinA(str[y])) str[y][x] = c + Text.tr;
  }
  
  /*
  public function render(ab:Bitmap, ox:Int, oy:Int):Void {
    
  }
  */
}
