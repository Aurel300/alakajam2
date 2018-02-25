package lib;

class RPG {
  public static inline var INITIAL_HEALTH = 1; //20;
  public static inline var INITIAL_STRENGTH = 5;
  
  public var maxHealth = INITIAL_HEALTH;
  public var strength = INITIAL_STRENGTH;
  public var speed = 1; // DEBUG 3;
  public var inventory:Array<Item> = [];
  public var equipped:Array<Item> = [];
  public var gold:Int = 0;
  public var changed:Bool = true;
  public var toxic:Int = 0;
  public var overburdened:Bool = false;
  public var kills:Int = 0;
  public var secrets:Int = 0;
  
  public var weapon(get, never):Item;
  function get_weapon():Item {
    for (i in equipped) switch(i.type) {
      case Weapon(_, _, _, _): return i;
      case _:
    }
    return null;
  }
  
  public var attack(get, never):Int;
  inline function get_attack():Int {
    var wpn = weapon;
    var wpnDmg = 1;
    if (wpn != null) switch (wpn.type) {
      case Weapon(dmg, _, _, _): wpnDmg = dmg;
      case _:
    }
    var min = strength.minI(wpnDmg);
    var max = strength.maxI(wpnDmg);
    return Chance.n(min, max);
  }
  
  public var stun(get, never):Int;
  inline function get_stun():Int {
    var wpn = weapon;
    var wpnStun = 1;
    if (wpn != null) switch (wpn.type) {
      case Weapon(_, _, stn, _): wpnStun = stn;
      case _:
    }
    return Chance.ch(wpnStun) ? wpnStun : 0;
  }
  
  public var poison(get, never):Int;
  inline function get_poison():Int {
    var wpn = weapon;
    var wpnPoi = 0;
    if (wpn != null) switch (wpn.type) {
      case Weapon(_, _, _, poi): wpnPoi = poi;
      case _:
    }
    return Chance.ch(wpnPoi) ? wpnPoi : 0;
  }
  
  public var capacity(get, never):Int;
  inline function get_capacity():Int {
    return 10 + (strength * 2.3).floor();
  }
  
  public var rate(get, never):Int;
  function get_rate():Int {
    var wpn = weapon;
    if (wpn != null) switch (wpn.type) {
      case Weapon(_, rt, _, _): return (10 - rt + (wpn.weight - (strength >> 2)).maxI(0)).maxI(1);
      case _:
    }
    return 10;
  }
  
  public var walkSpeed(get, never):Int;
  inline function get_walkSpeed():Int {
    return speed * (overburdened ? 2 : 1);
  }
  
  public var defense(get, never):Int;
  function get_defense():Int {
    var ret = 0;
    for (i in equipped) switch (i.type) {
      case Armour(_, def, _): ret += def;
      case _:
    }
    return ret;
  }
  
  public var thorns(get, never):Int;
  function get_thorns():Int {
    var ret = 0;
    for (i in equipped) switch (i.type) {
      case Armour(_, _, thrn): ret += thrn;
      case _:
    }
    return ret;
  }
  
  public function equippedType(t:ItemType):Item {
    var find = Item.itemTypeString(t);
    for (e in equipped) if (Item.itemTypeString(e.type) == find) return e;
    return null;
  }
  
  public function new() {
    inventory = [ for (i in 0...3) Procgen.createItem() ];
  }
  
  public function tick() {
    if (toxic > 0) {
      if (Chance.ch(5)) toxic--;
      else if (Chance.ch(1)) toxic++;
      else if (Chance.ch(1)) {
        toxic = (toxic - 5).maxI(0);
        Main.g.state.player.hurt(null, 0, 0, 1);
      }
    }
  }
}
