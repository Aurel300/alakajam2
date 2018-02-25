package lib;

class Enemy extends Entity {
  var letter:String;
  
  public function new(letter:String, x:Int, y:Int) {
    super(Enemy, Always);
    this.letter = letter;
    this.x = x;
    this.y = y;
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
