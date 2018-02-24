package lib;

class Enemy extends Entity {
  public function new() {
    super(Enemy, Hide);
    x = 5 + FM.prng.nextMod(10);
    y = 5 + FM.prng.nextMod(10);
  }
  
  override public function tick(state:GameState):Void {
    if (FM.prng.nextMod(10) == 0) {
      walkOrtho(FM.prng.nextMod(3) - 1, FM.prng.nextBool() ? 1 : -1);
    }
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.tp(pov) + "g");
  }
}
