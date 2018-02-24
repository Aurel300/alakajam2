package lib;

class Entity {
  public var room:RoomState;
  public var x:Int;
  public var y:Int;
  public var type:EntityType;
  public var povType:PovType;
  
  public function new(type:EntityType, povType:PovType) {
    this.type = type;
    this.povType = povType;
  }
  
  public function tick(state:GameState):Void {
    
  }
  
  public function print(str:Array<Array<String>>, pov:Int):Void {
    
  }
  
  public function moveTo(to:RoomState, tx:Int, ty:Int):Void {
    room.entities.remove(this);
    room = to;
    room.entities.push(this);
    x = tx;
    y = ty;
  }
  
  public inline function walkOrtho(ox:Int, oy:Int):Bool {
    return walk(ox, ox != 0 ? 0 : oy);
  }
  
  public function walk(ox:Int, oy:Int):Bool {
    var nx = x + ox;
    var ny = y + oy;
    if (!nx.withinI(0, room.w2 - 1) || !ny.withinI(0, room.h2 - 1)) return false;
    for (p in room.portals) {
      if (nx == p.fx && ny == p.fy) {
        moveTo(p.to, p.tx, p.ty);
        return true;
      }
    }
    switch (room.walls[room.indexTile(nx, ny)]) {
      case Solid: return false;
      case _:
    }
    for (e in room.entities) {
      if (e == this) continue;
      if (e.x == nx && e.y == ny) return false; // bump action
    }
    x = nx;
    y = ny;
    return true;
  }
  
  public inline function put(str:Array<Array<String>>, x:Int, y:Int, c:String):Void {
    if (y.withinA(str) && x.withinA(str[y])) str[y][x] = c + Text.tr;
  }
  
  /*
  public function render(ab:Bitmap, ox:Int, oy:Int):Void {
    
  }
  */
}
