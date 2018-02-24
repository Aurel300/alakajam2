package lib;

class Tape {
  static var TAPE_ID:Int = 0;
  
  public var id:Int;
  public var from:RoomState;
  public var to:RoomState;
  public var fromX:Int;
  public var fromY:Int;
  public var length:Int;
  public var vertical:Bool;
  
  public function new(from:RoomState, to:RoomState) {
    id = TAPE_ID++;
    this.from = from;
    this.to = to;
  }
}
