package lib;

class Scenario {
  public static function intro():Scenario {
    var ret = new Scenario();
    ret.story = new Story();
    var layout = new Layout();
    layout.rooms = [{
         state: new RoomState(Normal, 12, 12)
        ,x: 180
        ,y: 50
        ,z: 0
        ,tx: 180
        ,ty: 50
        ,tz: 0
      }, {
         state: new RoomState(Light, 20, 8)
        ,x: 0
        ,y: 0
        ,z: 0
        ,tx: 0
        ,ty: 0
        ,tz: 0
      }, {
         state: new RoomState(Normal, 15, 4)
        ,x: 70
        ,y: -90
        ,z: 0
        ,tx: 70
        ,ty: -40
        ,tz: 0
      }, {
         state: new RoomState(Normal, 15, 28) // options
        ,x: -370
        ,y: 112
        ,z: 0
        ,tx: 0
        ,ty: 112
        ,tz: 0
      }, {
         state: new RoomState(Normal, 15, 4)
        ,x: 120
        ,y: 340
        ,z: 0
        ,tx: 120
        ,ty: 340
        ,tz: 0
      }];
    var title = layout.rooms[1];
    var options = layout.rooms[3];
    layout.rooms[0].state.visuals.push(
        Photo("eye", 9, 9, 174, 174)
      );
    title.state.visuals.push(
        Text(Text.t(Regular3) + "Where is the truth  ?\n\n"
        + Text.t(Small3) + "A" + Text.c(2)
        + Text.t(Small3) + "by Aurel B%l&\nMade in 48" + Text.c(3)
        + Text.t(Small3) + "for Alakajam 2", 20, 20)
      );
    title.state.visuals.push(
        Text(Text.t(Mono1) + "[" + Text.t(Mono5) + "@" + Text.t(Mono1) + "]", 263, 84)
      );
            options.state.portWide(title.state, 4, 18, 1, title.state.h2 - 2, false);
            options.state.visited = true;
    title.state.walls[title.state.indexTile(40 - 6, 16 - 5)]
      = WallType.Trigger((player) -> {
          if (!options.state.visited) {
            options.state.portWide(title.state, 4, 18, 1, title.state.h2 - 2, false);
            options.state.visited = true;
          }
        });
    layout.rooms[2].state.visuals.push(
        JustifyFont("Control your " + Text.c(5) + " with WASD or the Ar" + Text.c(2) + " keys. Walk into the " + Text.c(2) + " when you are ready.", 9, 9, 15 * 16 - 18, Regular3)
      );
    layout.rooms[4].state.visuals.push(
        JustifyFont("Some things remain hidden until you left click. But, your " + Text.c(8) + " " + Text.c(18) + " !", 9, 9, 15 * 16 - 18, Regular3)
      );
    options.state.visuals.push(
        Text(Text.t(Mono1) + "NEW GAME\n\n" + [ for (y in 0...7) Text.t(Symbol) + "    B" ].join("\n\n\n\n"), 20, 20)
      );
    options.state.wallRect([
         1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        ,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1
        ,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1
        ,1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1
        ,1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
        ,1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
        ,1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
        ,1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
        ,1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
        ,1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
        ,1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      ].map(n -> n == 1 ? WallType.Solid : WallType.None), 2, 37, 26, 11);
    var curOpt = 20;
    var curY = 3;
    function option(title:String, opts:Array<{text:String, action:Entity->Void}>):Void {
      options.state.visuals.push(
          Text(Text.t(Regular3) + title, 135, curOpt)
        );
      curOpt += 16;
      curY += 2;
      for (o in opts) {
        options.state.visuals.push(
            Text(Text.t(Mono1) + "[" + Text.t(Mono5)
              + "@" + Text.t(Mono1) + "] " + Text.t(Regular3) + o.text, 135, curOpt)
          );
        options.state.walls[options.state.indexTile(18, curY)] = WallType.Trigger(o.action);
        curOpt += 16;
        curY += 2;
      }
      curOpt += 16;
      curY += 2;
    }
    option("Fullscreen", [
         {text: "Yes", action: (_) -> {}}
        ,{text: "No", action: (_) -> {}}
      ]);
    option("Scale", [
         {text: "1x", action: (_) -> {}}
        ,{text: "2x", action: (_) -> {}}
        ,{text: "3x", action: (_) -> {}}
        ,{text: "4x", action: (_) -> {}}
      ]);
    options.state.visuals.push(
        Text(Text.t(Mono1) + "[" + Text.t(Mono5)
          + "@" + Text.t(Mono1) + "] " + Text.t(Regular3) + "Start a new " + Text.c(4) + " ?", 39, 404)
      );
    var optTape = new Tape(options.state, title.state);
    optTape.fromX = 3;
    optTape.fromY = -1;
    optTape.vertical = false;
    optTape.length = 20;
    options.state.tapes.push(optTape);
    title.state.entities.push(new Player(18, 3));
    options.state.walls[options.state.indexTile(6, 51)] = WallType.Trigger((_) -> {});
    ret.floors = [layout];
    return ret;
  }
  
  public var story:Story;
  public var floors:Array<Layout>;
  
  public function new() {}
}
