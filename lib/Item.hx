package lib;

class Item {
  public static function itemTypeString(t:ItemType):String {
    return (switch (t) {
        case Weapon(_, _, _, _): "weapon";
        case Armour(Head, _, _): "armour-head";
        case Armour(Shoulder, _, _): "armour-shoulder";
        case Armour(Torso, _, _): "armour-torso";
        case Armour(Hand, _, _): "armour-hand";
        case Armour(Legs, _, _): "armour-legs";
        case Armour(Feet, _, _): "armour-feet";
        case Armour(Finger, _, _): "armour-finger";
        case Food(_, _, _): "food";
      });
  }
  
  public var type:ItemType;
  public var name:String;
  public var baseName:String;
  public var weight:Int;
  public var equipped(get, never):Bool;
  inline function get_equipped():Bool return Main.g.state.rpg.equipped.indexOf(this) != -1;
  
  public var isFood(get, never):Bool;
  inline function get_isFood():Bool return itemTypeString(type) == "food";
  
  public var action(get, never):String;
  inline function get_action():String return isFood ? "Consume" : (equipped ? "Unequip item" : "Equip item");
  
  public function doAction():Void {
    if (isFood) consume();
    else if (equipped) unequip();
    else equip();
    Main.g.state.rpg.changed = true;
  }
  
  public function consume():Void {
    switch (type) {
      case Food(heal, toxic, poison):
      Main.g.ren.log('You consume ${this.name}.');
      Main.g.state.player.hurt(null, -heal, 0, poison);
      Main.g.state.rpg.inventory.remove(this);
      Main.g.state.rpg.changed = true;
      case _:
    }
  }
  
  public function drop():Void {
    unequip();
    Main.g.ren.log('You drop ${this.name}.');
    Main.g.state.charPaused.add(new ItemDrop(this, Main.g.state.charPausedX, Main.g.state.charPausedY));
    Main.g.state.rpg.inventory.remove(this);
    Main.g.state.rpg.changed = true;
  }
  
  public function unequip():Void {
    if (Main.g.state.rpg.equipped.remove(this)) {
      Main.g.state.rpg.changed = true;
      Main.g.ren.log('You unequip ${this.name}.');
      SFX.p("unequip");
    }
  }
  
  public function equip():Void {
    var prev = Main.g.state.rpg.equippedType(type);
    if (prev != null) prev.unequip();
    Main.g.state.rpg.equipped.push(this);
    Main.g.ren.log('You equip ${this.name}.');
    SFX.p("equip");
  }
  
  public var price(get, never):Int;
  function get_price():Int {
    var base = 5.0;
    switch (type) {
      case Weapon(dmg, rate, stun, push):
      base += dmg * 2;
      base += 50 - rate * 3;
      base += stun * 10;
      base += push * 20;
      case Armour(_, def, thorn):
      base += def * 1.5;
      base += thorn * 4;
      case Food(heal, toxic, poison):
      base += heal;
      base -= toxic * 2.0;
      base -= poison * 2.5;
    }
    base -= weight * 0.2;
    return base.floor().maxI(1);
  }
  
  public function new() {}
}
