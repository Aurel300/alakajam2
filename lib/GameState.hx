package lib;

class GameState {
  public var layout:Layout;
  public var player:Player;
  public var mouseRoom:RoomState = null;
  public var mouseX:Int = -1;
  public var mouseY:Int = -1;
  
  public function new() {
    layout = new Layout();
    layout.rooms = [
         {state: new RoomState(), x: 50, y: 50, z: 0, tx: 100, ty: 50, tz: 0}
        ,{state: new RoomState(), x: 90, y: 80, z: 0, tx: 130, ty: 40, tz: 0}
      ];
    layout.rooms[0].state.entities.push(player = new Player());
  }
  
  public function tick() {
    for (room in layout.rooms) {
      room.state.tick();
    }
  }
}
