package lib;

class Entity {
  public var room:RoomState;
  public var x:Int;
  public var y:Int;
  public var type:EntityType;
  
  public function new(type:EntityType) {
    this.type = type;
  }
  
  public function tick():Void {
    
  }
  
  public function print(str:Array<Array<String>>):Void {
    
  }
  
  /*
  public function render(ab:Bitmap, ox:Int, oy:Int):Void {
    
  }
  */
}
