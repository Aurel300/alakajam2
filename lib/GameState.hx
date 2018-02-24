package lib;

class GameState {
  public var layout:Layout;
  public var player:Player;
  public var mouseRoom:RoomState = null;
  public var mouseX:Int = -1;
  public var mouseY:Int = -1;
  public var rpg:RPG;
  public var keys = {
       left: false
      ,up: false
      ,right: false
      ,down: false
    };
  
  public function new() {
    rpg = new RPG();
    layout = new Layout();
    layout.rooms = [
        {state: new RoomState(), x: 50, y: 50, z: 0, tx: 100, ty: 50, tz: 0}
      ];
    layout.rooms[0].state.entities.push(player = new Player());
    for (i in 0...5) {
      layout.rooms[0].state.entities.push(new Enemy());
    }
    for (e in layout.rooms[0].state.entities) e.room = layout.rooms[0].state;
  }
  
  public function tick() {
    for (room in layout.rooms) {
      room.state.tick(this);
    }
    player.room.revealRect(
        player.x - 1, player.y - 1, player.x + 1, player.y + 1
      );
  }
  
  public function vision() {
    if (mouseRoom != null && player.room == mouseRoom) {
      mouseRoom.vision(player.x, player.y, mouseX, mouseY);
    }
  }
}
