package lib;

class GameState {
  public var scenario:Scenario;
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
    scenario = Procgen.createScenario();
    layout = scenario.floors[0];
    layout.rooms[0].state.entities.push(player = new Player());
    for (r in layout.rooms) r.state.fix();
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
