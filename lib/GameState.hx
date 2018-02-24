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
      ];
    layout.rooms[0].state.entities.push(player = new Player());
    player.room = layout.rooms[0].state;
  }
  
  public function tick() {
    for (room in layout.rooms) {
      room.state.tick();
    }
  }
  
  public function vision() {
    if (mouseRoom != null && player.room == mouseRoom) {
      mouseRoom.vision(player.x, player.y, mouseX, mouseY);
    }
  }
}
