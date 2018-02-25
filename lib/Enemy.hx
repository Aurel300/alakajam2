package lib;

class Enemy extends Entity {
  var letter:String;
  var holding:Array<Item> = [];
  var gold = 0;
  var cdAttack = 0;
  
  public function new(letter:String, x:Int, y:Int) {
    super(Enemy, Always);
    this.letter = letter;
    if (FM.prng.nextMod(5) == 0) holding = [Procgen.createItem()];
    if (FM.prng.nextMod(4) == 0) gold = 1 + FM.prng.nextMod(30);
    health = 5;
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
    other.hurt(this, 1, 0, 0);
    cdAttack = 10;
  }
  
  override public function hurt(by:Entity, attack:Int, stun:Int, poison:Int):Bool {
    if (super.hurt(by, attack, stun, poison)) {
      for (i in holding) room.add(new ItemDrop(i, x, y));
      if (gold > 0) room.add(new GoldDrop(gold, x, y));
      Main.g.state.framePause += 20;
      SFX.p("player-kill");
      return true;
    } else {
      SFX.p("enemy-hurt");
    }
    return false;
  }
  
  override public function tick(state:GameState):Void {
    super.tick(state);
    if (!room.visited || stun > 0) return;
    if (cdAttack > 0) cdAttack--;
    if (FM.prng.nextMod(10) == 0) {
      walkOrtho(FM.prng.nextMod(3) - 1, FM.prng.nextBool() ? 1 : -1);
    }
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.tp(pov) + letter);
  }
}
