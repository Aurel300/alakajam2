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
  public var charSheet:RoomLayout;
  public var charTween:Bitween;
  public var charPaused:RoomState;
  public var charPausedX:Int;
  public var charPausedY:Int;
  public var framePause:Int = 0;
  
  public function new() {
    Main.g.state = this;
    rpg = new RPG();
    charSheet = Scenario.charSheet();
    charTween = new Bitween(5/*50*/);
    charTween.setTo(true, false);
    //scenario = Scenario.intro();
    scenario = Procgen.createScenario();
    selectFloor(0);
  }
  
  public function selectFloor(n:Int):Void {
    if (layout != null) layout.rooms.remove(charSheet);
    layout = scenario.floors[n];
    layout.rooms.push(charSheet);
    for (r in layout.rooms) {
      for (e in r.state.entities) if (e.type == Player) {
        player = (cast e:Player);
        break;
      }
      r.state.fix();
    }
  }
  
  public function tick() {
    if (framePause > 0) {
      framePause--;
      return;
    }
    rpg.tick();
    var wasChar = charTween.isOn || charTween.value == charTween.length;
    charTween.tick();
    if (wasChar != charTween.isOn) {
      if (charTween.isOn) {
        charPaused = player.room;
        charPausedX = player.x;
        charPausedY = player.y;
        player.isCharSheet = true;
        player.moveTo(charSheet.state, 14, 18);
      } else {
        player.isCharSheet = false;
        player.moveTo(charPaused, charPausedX, charPausedY);
      }
    }
    if (!charTween.isOff) {
      charSheet.state.tick(this);
      return;
    }
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
      if (mouseRoom.type != CharSheet) {
        SFX.p("vision");
      }
    }
  }
}
