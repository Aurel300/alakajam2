package lib;

import sk.thenet.stream.bmp.Bresenham;

class RoomState {
  static var ROOM_ID:Int = 0;
  static inline var POV_STRENGTH:Float = 100;
  
  public var id:Int;
  public var width:Int;
  public var height:Int;
  public var w2:Int;
  public var h2:Int;
  public var wh:Int;
  public var wh4:Int;
  public var mask:Vector<Bool>;
  public var walls:Vector<WallType>;
  public var pov:Vector<Int>;
  public var entities:Array<Entity> = [];
  public var type:RoomType;
  public var title:String;
  public var boundary:Vector<Point2DI>;
  
  public function new() {
    id = ROOM_ID++;
    width = 10;
    height = 20;
    wh = width * height;
    w2 = width * 2;
    h2 = height * 2;
    wh4 = w2 * h2;
    mask = Vector.fromArrayCopy([ for (i in 0...wh) 1 ].map(n -> n > 0));
    walls = Vector.fromArrayCopy([ for (y in 0...h2) for (x in 0...w2)
        //x == 0 || x == w2 - 1 || y == 0 || y == height * 2 - 1 || FM.prng.nextBool() ? WallType.None : WallType.Solid
        x == 1 || x == w2 - 2 || y == 1 || y == h2 - 2 ? WallType.Solid : WallType.None
      ]);
    pov = Vector.fromArrayCopy([ for (i in 0...wh4) 0 ]);
    boundary = new Vector<Point2DI>(w2 + h2 - 4);
    var bvi = 0;
    for (x in 0...w2) {
      boundary[bvi++] = new Point2DI(x, 0);
      boundary[bvi++] = new Point2DI(x, h2 - 1);
    }
    for (y in 1...h2 - 1) {
      boundary[bvi++] = new Point2DI(0, y);
      boundary[bvi++] = new Point2DI(w2 - 1, y);
    }
  }
  
  public function tick() {
    for (e in entities) e.tick();
    for (i in 0...wh4) if (pov[i] > 0) pov[i]--;
  }
  
  public function vision(px:Int, py:Int, mx:Int, my:Int) {
    var from = new Point2DI(px, py);
    //var fromF = new Point2DF(px, py);
    var angle = Math.atan2(my - py * 8 + 4, mx - px * 8 + 4);
    trace(angle);
    var c1 = new Point2DF(Math.cos(angle - Math.PI / 4), Math.sin(angle - Math.PI / 4));
    var c2 = new Point2DF(Math.cos(angle + Math.PI / 4), Math.sin(angle + Math.PI / 4));
    for (ray in boundary) {
      var power = 1.0;
      var rp = new Point2DF(ray.x - px, ray.y - py);
      var dp1 = rp.dot(c1);
      var dp2 = rp.dot(c2);
      trace(dp1, dp2);
      if (dp1 < 0 || dp2 < 0) continue;
      for (pt in new Bresenham(from, ray)) {
        var mi = pt.y * w2 + pt.x;
        pov[mi] += (power * POV_STRENGTH).floor();
        switch (walls[mi]) {
          case Solid: power -= 1;
          case _:
        }
        if (power < 0.001) break;
      }
    }
  }
}
