package lib;

class ItemDrop extends Entity {
  public var item:Item;
  var letter:String;
  
  public function new(item:Item, x:Int, y:Int) {
    super(ItemDrop, Fade);
    this.item = item;
    letter = item.baseName.charAt(0).toLowerCase();
    this.x = x;
    this.y = y;
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.t(Item) + letter);
  }
}
