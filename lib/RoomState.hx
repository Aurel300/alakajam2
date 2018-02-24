package lib;

class RoomState {
  static var ROOM_ID:Int = 0;
  
  public var id:Int;
  public var width:Int;
  public var height:Int;
  public var wh:Int;
  public var wh4:Int;
  public var mask:Vector<Bool>;
  public var walls:Vector<WallType>;
  public var pov:Vector<Int>;
  public var entities:Array<Entity> = [];
  public var type:RoomType;
  public var title:String;
  
  public function new() {
    id = ROOM_ID++;
    width = 10;
    height = 20;
    wh = width * height;
    wh4 = wh * 4;
    mask = Vector.fromArrayCopy([ for (i in 0...wh) 1 ].map(n -> n > 0));
    walls = Vector.fromArrayCopy([ for (y in 0...height * 2) for (x in 0...width * 2)
        x == 0 || x == width * 2 - 1 || y == 0 || y == height * 2 - 1 || FM.prng.nextBool() ? WallType.None : WallType.Solid
      ]);
    pov = Vector.fromArrayCopy([ for (i in 0...wh4) 0 ]);
  }
  
  public function tick() {
    for (e in entities) e.tick();
    for (i in 0...wh4) if (pov[i] > 0) pov[i]--;
  }
}
