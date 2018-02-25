package lib;

class Enemy extends Entity {
  var letter:String;
  var holding:Array<Item> = [];
  var gold:Int = 0;
  
  public function new(letter:String, x:Int, y:Int) {
    super(Enemy, Always);
    this.letter = letter;
    if (FM.prng.nextMod(5) == 0) holding = [Item.drop()];
    if (FM.prng.nextMod(4) == 0) gold = 1 + FM.prng.nextMod(30);
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
  
  public function hurt():Void {
    for (i in holding) room.entities.push(new ItemDrop(i, x, y));
    if (gold > 0) room.entities.push(new GoldDrop(gold, x, y));
    room.fix();
    Main.g.state.framePause += 20;
    remove();
  }
  
  override public function tick(state:GameState):Void {
    super.tick(state);
    if (!room.visited) return;
    if (FM.prng.nextMod(10) == 0) {
      walkOrtho(FM.prng.nextMod(3) - 1, FM.prng.nextBool() ? 1 : -1);
    }
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.tp(pov) + letter);
  }
}
