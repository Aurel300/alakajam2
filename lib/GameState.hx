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
  public var isGame:Bool = false;
  public var floor:Int = 0;
  
  public function new() {
    Main.g.state = this;
    menu();
    //start(); // DEBUG
  }
  
  public function menu():Void {
    isGame = false;
    loadScenario(Scenario.intro());
  }
  
  public function start():Void {
    isGame = true;
    Switcher.tasks = Procgen.createScenario();
    Main.g.st("switcher");
  }
  
  public function nextLevel():Void {
    if (floor == scenario.floors.length - 1) {
      Message.msg = Text.c(7) + Text.t(Regular) + ", you have successfully\ncompleted your investigation!\n"
        + 'You have collected ${rpg.gold} GP\n'
        + '      slain ${rpg.kills} foes\n'
        + '      and discovered ${rpg.secrets} ' + Text.c(4) + Text.t(Regular) + "\n\n"
        + "Click to " + Text.c(4) + Text.t(Regular) + " to H" + Text.c(8);
      Main.g.st("message");
      SFX.p("victory");
    } else {
      selectFloor(floor + 1);
    }
  }
  
  public function loadScenario(s:Scenario):Void {
    rpg = new RPG();
    charSheet = Scenario.charSheet();
    charTween = new Bitween(5/*50*/);
    scenario = s;
    selectFloor(0);
  }
  
  public function selectFloor(n:Int):Void {
    floor = n;
    if (layout != null) layout.rooms.remove(charSheet);
    layout = scenario.floors[n];
    layout.rooms.push(charSheet);
    var oldHp = -1;
    if (isGame && player != null) {
      oldHp = player.health;
    }
    for (r in layout.rooms) {
      for (e in r.state.entities) if (e.type == Player) {
        player = (cast e:Player);
        break;
      }
      r.state.fix();
    }
    player.rpg = rpg;
    if (oldHp != -1) {
      player.health = oldHp;
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
    player.room.vision(player.x, player.y, mouseX, mouseY);
    if (player.room.type != CharSheet) {
      SFX.p("vision");
    }
  }
}
