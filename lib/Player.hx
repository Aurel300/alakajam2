package lib;

class Player extends Entity {
  public var isCharSheet:Bool = false;
  var cdWalk = 0;
  var cdAttack = 0;
  public var rpg:RPG;
  
  public function new(x:Int, y:Int) {
    super(Player, Always);
    health = RPG.INITIAL_HEALTH;
    this.x = x;
    this.y = y;
  }
  
  override public function pickUpItem(i:Item):Bool {
    Main.g.ren.log('You pick up ${i.name}.');
    SFX.p("chest");
    rpg.inventory.push(i);
    rpg.changed = true;
    return true;
  }
  
  override public function pickUpGold(g:Int):Bool {
    Main.g.ren.log('You pick up ${g} GP.');
    SFX.p("gold");
    rpg.gold += g;
    rpg.changed = true;
    return true;
  }
  
  override public function attack(other:Entity):Void {
    if (cdAttack != 0 || stun != 0) return;
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
      Main.g.ren.log('You take ${attack} damage.');
      SFX.p("player-hurt");
    } else if (attack < 0) {
      Main.g.ren.log('Your life is restored by ${-attack} HP.');
      SFX.p("heal");
    }
    var dead = super.hurt(by, attack, stun, poison);
    if (dead) {
      Message.msg = Text.c(7) + Text.t(Regular) + ", you have been " + Text.c(3) + Text.t(Regular) + "\n"
        + 'You have collected ${rpg.gold} GP\n'
        + '      slain ${rpg.kills} foes\n'
        + '      and discovered ${rpg.secrets} ' + Text.c(4) + Text.t(Regular) + "\n\n"
        + "Click to " + Text.c(4) + Text.t(Regular) + " to H" + Text.c(8);
      Main.g.st("message");
      SFX.p("player-death");
    } else {
      if (stun > 0) Main.g.ren.log("You are stunned!");
      if (poison > 0) Main.g.ren.log("You are poisoned!");
    }
    health = health.minI(rpg.maxHealth);
    stun = stun.maxI(0);
    poison = poison.maxI(0);
    return dead;
  }
  
  override public function tick(state:GameState):Void {
    if (rpg == null) return;
    if (!room.visited) {
      SFX.p("page");
      if (room.type == Clipping) {
        Main.g.ren.log('You found a ' + Text.c(4) + Text.t(Small) + "!");
        rpg.secrets++;
      } else {
        Main.g.ren.log('A new room ...');
      }
      state.framePause = 30;
      room.visited = true;
    }
    if (isCharSheet) {
      x += (1).negposI(state.keys.left, state.keys.right);
      y += (1).negposI(state.keys.up, state.keys.down);
      x = x.clampI(2, room.w2 - 3);
      y = y.clampI(2, room.height * 2 - 3);
      return;
    }
    if (cdWalk == 0 && stun == 0) {
      if (walkOrtho(
           (1).negposI(state.keys.left, state.keys.right)
          ,(1).negposI(state.keys.up, state.keys.down)
        )) {
        cdWalk = rpg.walkSpeed;
        if (Chance.ch(20)) SFX.p("player-step");
      }
    } else cdWalk--;
    if (cdAttack > 0) cdAttack--;
    super.tick(state);
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.t(FontType.Mono1 + (((19 + cdAttack) / 20).floor()).minI(4)) + "@");
  }
}
