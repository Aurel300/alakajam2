package lib;

class Renderer {
  public static inline var ROOM_SIZE = 16;
  public static inline var TILE_SIZE = 8;
  
  public static var roomPieces:Array<Bitmap>;
  
  public static function init(am:AssetManager):Void {
    var s = am.getBitmap("paper").fluent;
    roomPieces = [ for (y in 0...3) for (x in 0...3)
        s >> new Cut(x * 16, 8 + y * 16, 16, 16)
      ].concat([ for (y in 0...2) for (x in 0...2)
        s >> new Cut(48 + x * 16, 8 + y * 16, 16, 16)
      ]);
  }
  
  var cacheBg = new Map<Int, Bitmap>();
  var cacheText = new Map<Int, {txt:Array<String>, txtres:Array<Bitmap>, res:Bitmap}>();
  
  public function new() {
    
  }
  
  public function mouseMove(state:GameState, mx:Int, my:Int):Void {
    state.mouseRoom = null;
    var len = state.layout.rooms.length;
    for (ri in 0...len) {
      var room = state.layout.rooms[len - ri - 1];
      var rx = room.x.floor();
      var ry = room.y.floor() - room.z.floor();
      if (mx.withinI(rx, rx + room.state.width * ROOM_SIZE - 1)
          && my.withinI(ry, ry + room.state.height * ROOM_SIZE - 1)) {
        state.mouseRoom = room.state;
        state.mouseX = mx - rx;
        state.mouseY = my - ry;
        break;
      }
    }
  }
  
  public function render(state:GameState, ab:Bitmap):Void {
    ab.fill(Colour.BLACK);
    state.layout.rooms.map(renderRoom.bind(_, state, ab));
  }
  
  function renderRoom(room:RoomLayout, state:GameState, ab:Bitmap):Void {
    if (!cacheBg.exists(room.state.id)) {
      var rb = Platform.createBitmap(
          ROOM_SIZE * room.state.width, ROOM_SIZE * room.state.height, 0
        );
      var vi = 0;
      for (y in 0...room.state.height) for (x in 0...room.state.width) {
        if (!room.state.mask[vi]) {
          vi++;
          continue;
        }
        var rp = 0;
        var x1 = x > 0;
        var x2 = x < room.state.width - 1;
        var y1 = y > 0;
        var y2 = y < room.state.height - 1;
        var ng = 0;
        if (x2 && room.state.mask[vi + 1]) ng += 1;
        if (y2 && room.state.mask[vi + room.state.width]) ng += 2;
        if (x1 && room.state.mask[vi - 1]) ng += 4;
        if (y1 && room.state.mask[vi - room.state.width]) ng += 8;
        var dng = if (x2 && y2 && !room.state.mask[vi + 1 + room.state.width]) 9;
          else if (x1 && y2 && !room.state.mask[vi - 1 + room.state.width]) 10;
          else if (x2 && y1 && !room.state.mask[vi + 1 - room.state.width]) 11;
          else if (x1 && y1 && !room.state.mask[vi - 1 - room.state.width]) 12;
          else 4;
        rp = [
             0, 0, 0, 0
            ,0, 0, 2, 1
            ,0, 6, 0, 3
            ,8, 7, 5, dng
          ][ng];
        rb.blitAlpha(roomPieces[rp], x * ROOM_SIZE, y * ROOM_SIZE);
        vi++;
      }
      if (room.state.title != null) Text.render(rb, 9, 9, room.state.title);
      cacheBg[room.state.id] = rb;
    }
    {
      if (!cacheText.exists(room.state.id)) {
        cacheText[room.state.id] = {
             txt: [ for (y in 0...room.state.height * 2) null ]
            ,txtres: [ for (y in 0...room.state.height * 2)
              Platform.createBitmap(ROOM_SIZE * room.state.width, 15, 0) ]
            ,res: Platform.createBitmap(ROOM_SIZE * room.state.width, ROOM_SIZE * room.state.height, 0)
          };
      }
      var vi = -1;
      var str:Array<Array<String>> = [ for (y in 0...room.state.height * 2)
          [ for (x in 0...room.state.width * 2) switch (room.state.walls[++vi]) {
              case Solid: Text.tp(room.state.pov[vi]) + "#" + Text.tr;
              case _: " ";
            } ]
        ];
      for (e in room.state.entities) {
        e.print(str);
      }
      var txt = str.map(l -> l.join(""));
      var mod = false;
      for (i in 0...txt.length) {
        if (txt[i] != cacheText[room.state.id].txt[i]) {
          cacheText[room.state.id].txt[i] = txt[i];
          cacheText[room.state.id].txtres[i].fill(0);
          Text.render(cacheText[room.state.id].txtres[i], -1, 0, txt[i], Text.REG);
          mod = true;
        }
      }
      if (mod) {
        cacheText[room.state.id].res.fill(0);
        for (i in 0...txt.length) {
          cacheText[room.state.id].res.blitAlpha(
              cacheText[room.state.id].txtres[i], 0, -4 + i * 8
            );
        }
      }
    }
    room.x.target(room.tx, 19);
    room.y.target(room.ty, 19);
    room.z.target(room.tz, 29);
    var rx = room.x.floor();
    var ry = room.y.floor() - room.z.floor();
    ab.blitAlpha(cacheBg[room.state.id], rx, ry);
    ab.blitAlpha(cacheText[room.state.id].res, rx, ry);
    if (room.state == state.mouseRoom) {
      ab.set(rx + state.mouseX, ry + state.mouseY, Colour.BLUE);
    }
  }
}
