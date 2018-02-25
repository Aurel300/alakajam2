package lib;

class Enemy extends Entity {
  var letter:String;
  var holding:Array<Item> = [];
  var atkDmg = 0;
  var atkStun = 0;
  var atkPoison = 0;
  var beh = 0;
  var gold = 0;
  var cdAttack = 0;
  var timer = 0;
  public var alarmed = false;
  
  public function new(letter:String, x:Int, y:Int) {
    super(Enemy, Fade);
    this.letter = letter;
    if (FM.prng.nextMod(5) == 0) holding = [Procgen.createItem()];
    if (FM.prng.nextMod(4) == 0) gold = 1 + FM.prng.nextMod(30);
    health = 5 + (Main.g.state.rpg.kills >> 2) + Chance.n2(1, 1 + Main.g.state.rpg.kills * 2);
    atkDmg = Chance.n2(1, 1 + (Main.g.state.rpg.kills >> 3));
    if (Chance.ch(Chance.n2(1, Main.g.state.rpg.kills))) atkStun = Chance.n(1, 3);
    if (Chance.ch(Chance.n2(1, Main.g.state.rpg.kills) - 20)) atkPoison = Chance.n(1, 5);
    beh = Chance.n2(0, 3);
    this.x = x;
    this.y = y;
  }
  
  override public function pickUpItem(i:Item):Bool {
    holding.push(i);
    return true;
  }
  
  override public function pickUpGold(g:Int):Bool {
    gold += g;
    return true;
  }
  
  override public function attack(other:Entity):Void {
    if (cdAttack != 0) return;
    other.hurt(this, atkDmg, atkStun, atkPoison);
    cdAttack = 10;
  }
  
  override public function hurt(by:Entity, attack:Int, stun:Int, poison:Int):Bool {
    if (super.hurt(by, attack, stun, poison)) {
      for (i in holding) room.add(new ItemDrop(i, x, y));
      if (gold > 0) room.add(new GoldDrop(gold, x, y));
      Main.g.state.framePause += 20;
      Main.g.ren.log('You have slain a foe!');
      SFX.p("player-kill");
      Main.g.state.rpg.kills++;
      if (Chance.ch(15)) {
        if (Main.g.state.rpg.speed > 1 && Chance.ch(4)) {
          Main.g.ren.log('You feel faster!');
          Main.g.state.rpg.speed--;
        } else if (Chance.ch(30)) {
          Main.g.ren.log('You feel stronger!');
          Main.g.state.rpg.strength++;
        } else {
          Main.g.ren.log('You feel more resilient!');
          Main.g.state.rpg.maxHealth++;
          by.health++;
        }
      }
      return true;
    } else {
      Main.g.ren.log('You hurt the enemy for ${attack} damage.');
      SFX.p("enemy-hurt");
    }
    return false;
  }
  
  override public function tick(state:GameState):Void {
    super.tick(state);
    if (!room.visited || stun > 0) return;
    if (pov > 0 && !alarmed) {
      SFX.p("alert");
      if (atkStun > 0) Main.g.ren.log('This ${letter} looks rather muscular.');
      if (atkPoison > 0) Main.g.ren.log('You smell poison on ${letter}.');
      alarmed = true;
    }
    if (!alarmed) return;
    if (cdAttack > 0) cdAttack--;
    switch (beh) {
      case 0:
      if (FM.prng.nextMod(10) == 0) {
        walkOrtho(FM.prng.nextMod(3) - 1, FM.prng.nextBool() ? 1 : -1);
      }
      case 1:
      timer++;
      if (timer >= 5) {
        walkOrtho(FM.prng.nextMod(3) - 1, FM.prng.nextBool() ? 1 : -1);
        timer = 0;
      }
      case 2:
      timer++;
      if (Main.g.state.player.room == room) {
        var dx = Main.g.state.player.x - x;
        var dy = Main.g.state.player.y - y;
        var td = dx.absI() + dy.absI();
        if (Chance.ch(100 - td * 30) && timer >= 50) {
          timer = 0;
          walk(dx.clampI(-1, 1), dy.clampI(-1, 1));
        }
      }
      case _:
      timer++;
      if (Main.g.state.player.room == room) {
        var dx = Main.g.state.player.x - x;
        var dy = Main.g.state.player.y - y;
        var td = dx.absI() + dy.absI();
        if (Chance.ch(100 - td * 5) && timer >= Chance.n2(10, 50)) {
          walk(dx.clampI(-1, 1), dy.clampI(-1, 1));
        }
      }
    }
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.tp(pov) + letter);
  }
}
