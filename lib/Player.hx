package lib;

class Player extends Entity {
  public var isCharSheet:Bool = false;
  var cdWalk = 0;
  var cdAttack = 0;
  var rpg:RPG;
  
  public function new(x:Int, y:Int) {
    super(Player, Always);
    health = RPG.INITIAL_HEALTH;
    this.x = x;
    this.y = y;
    rpg = Main.g.state.rpg;
  }
  
  override public function pickUpItem(i:Item):Bool {
    trace("picked up " + i.name);
    rpg.inventory.push(i);
    rpg.changed = true;
    return true;
  }
  
  override public function pickUpGold(g:Int):Bool {
    trace("picked up " + g);
    rpg.gold += g;
    rpg.changed = true;
    return true;
  }
  
  override public function attack(other:Entity):Void {
    if (cdAttack != 0) return;
    other.hurt(this, rpg.attack, rpg.stun, rpg.poison);
    cdAttack = rpg.rate;
  }
  
  override public function hurt(by:Entity, attack:Int, stun:Int, poison:Int):Bool {
    rpg.changed = true;
    if (attack > 0) {
      var thorns = rpg.thorns;
      if (Chance.ch(thorns)) {
        by.hurt(this, attack, stun, poison);
      }
      attack = (attack - Chance.n(rpg.defense >> 1, rpg.defense)).maxI(0);
    }
    var dead = super.hurt(by, attack, stun, poison);
    health = health.minI(rpg.maxHealth);
    stun = stun.maxI(0);
    poison = poison.maxI(0);
    return dead;
  }
  
  override public function tick(state:GameState):Void {
    room.visited = true;
    if (isCharSheet) {
      x += (1).negposI(state.keys.left, state.keys.right);
      y += (1).negposI(state.keys.up, state.keys.down);
      x = x.clampI(2, room.w2 - 3);
      y = y.clampI(2, room.height * 2 - 3);
      return;
    }
    if (cdWalk == 0) {
      if (walkOrtho(
           (1).negposI(state.keys.left, state.keys.right)
          ,(1).negposI(state.keys.up, state.keys.down)
        )) cdWalk = rpg.walkSpeed;
    } else cdWalk--;
    if (cdAttack > 0) cdAttack--;
    super.tick(state);
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.t(FontType.Mono1 + (((19 + cdAttack) / 20).floor()).minI(4)) + "@");
  }
}
