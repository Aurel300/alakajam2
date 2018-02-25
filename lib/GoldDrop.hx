package lib;

class GoldDrop extends Entity {
  public var gold:Int;
  
  public function new(gold:Int, x:Int, y:Int) {
    super(GoldDrop, Fade);
    this.gold = gold;
    this.x = x;
    this.y = y;
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.t(Item) + ".");
  }
}
