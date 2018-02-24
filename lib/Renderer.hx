package lib;

class Renderer {
  public static inline var ROOM_SIZE = 16;
  public static inline var TILE_SIZE = 8;
  static inline var DESK_W = 25 * ROOM_SIZE;
  static inline var DESK_H = 19 * ROOM_SIZE;
  
  public static var roomPieces:Array<Bitmap>;
  public static var desk:Array<Bitmap>;
  public static var tape:Bitmap;
  
  public static function init(am:AssetManager):Void {
    var s = am.getBitmap("paper").fluent;
    roomPieces = [ for (y in 0...3) for (x in 0...3)
        s >> new Cut(x * 16, 8 + y * 16, 16, 16)
      ].concat([ for (y in 0...2) for (x in 0...2)
        s >> new Cut(48 + x * 16, 8 + y * 16, 16, 16)
      ]);
    desk = [ for (y in 0...3) for (x in 0...4)
        s >> new Cut(112 + x * 16, 8 + y * 16, 16, 16)
      ];
    tape = s >> new Cut(80, 40, 32, 32);
  }
  
  var cacheDesk:Bitmap;
  var cacheBg = new Map<Int, Bitmap>();
  var cacheText = new Map<Int, {txt:Array<String>, txtres:Array<Bitmap>, res:Bitmap}>();
  var cacheTape = new Map<Int, Bitmap>();
  
  var camX:Float = 0;
  var camY:Float = 0;
  
  public function new() {
    var cd = Platform.createBitmap(DESK_W, DESK_H, Pal.paper[8]);
    for (y in 0...19) {
      var cpos = FM.prng.nextMod(desk.length);
      var cy = 0;
      for (x in 0...25) {
        cd.blitAlpha(desk[cpos], x * 16, 5 + y * 24 + cy);
        cpos++;
        cy = (cy + FM.prng.nextMod(3) - 1).clampI(-3, 3);
        if (FM.prng.nextMod(15) == 0) cpos = FM.prng.nextMod(desk.length);
        cpos %= desk.length;
      }
    }
    cacheDesk = Platform.createBitmap(2 * cd.width, 2 * cd.height, 0);
    for (y in 0...2) for (x in 0...2) cacheDesk.blit(cd, x * cd.width, y * cd.height);
  }
  
  public function mouseMove(state:GameState, mx:Int, my:Int):Void {
    state.mouseRoom = null;
    var len = state.layout.rooms.length;
    for (ri in 0...len) {
      var room = state.layout.rooms[len - ri - 1];
      var rx = room.x.floor() - camX.floor();
      var ry = room.y.floor() - room.z.floor() - camY.floor();
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
    for (l in state.layout.rooms) {
      if (l.state == state.player.room) {
        camX.target(l.x + state.player.x * TILE_SIZE + 4 - Main.WH, 29);
        camY.target(l.y + state.player.y * TILE_SIZE + 4 - Main.HH, 29);
        break;
      }
    }
    var dx = ((camX / DESK_W).floor() * DESK_W - camX).floor();
    var dy = ((camY / DESK_H).floor() * DESK_H - camY).floor();
    ab.blit(cacheDesk, dx, dy);
    state.layout.rooms.map(renderRoom.bind(_, state, ab));
    for (l in state.layout.rooms) {
      for (t in l.state.tapes) {
        if (t.from == l.state && (t.from.visited || t.to.visited)) {
          renderTape(t, l, ab);
        }
      }
    }
  }
  
  function renderTape(tape:Tape, from:RoomLayout, ab:Bitmap):Void {
    var rb = cacheTape[tape.id];
    if (rb == null) {
      rb = Platform.createBitmap(
           TILE_SIZE * (tape.vertical ? 4 : tape.length.absI())
          ,TILE_SIZE * (tape.vertical ? tape.length.absI() : 4), 0
        );
      rb.blitAlpha(Renderer.tape.fluent >> new Box(
           new Point2DI(8, 8), new Point2DI(24, 24)
          ,rb.width, rb.height
        ), 0, 0);
      cacheTape[tape.id] = rb;
    }
    var tapeX = from.x + tape.fromX * TILE_SIZE;
    var tapeY = from.y + tape.fromY * TILE_SIZE;
    if (tape.length < 0) {
      if (tape.vertical) {
        tapeY += (tape.length + 2) * TILE_SIZE;
      } else {
        tapeX += (tape.length + 2) * TILE_SIZE;
      }
    }
    var rx = tapeX.floor() - camX.floor();
    var ry = tapeY.floor() - camY.floor();
    if (rx < Main.W && ry < Main.H && rx >= -rb.width && ry >= -rb.height) {
      ab.blitAlpha(rb, rx, ry);
    }
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
      //rb.blitAlpha(Main.g.amB("paper-sub"), 9, 9);
      if (room.state.title != null) Text.render(rb, 9, 9, room.state.title);
      for (v in room.state.visuals) switch (v) {
        case Justify(txt, x, y, w):
        rb.blitAlpha(Text.justify(txt, w).res, x, y);
        case Photo(id, x, y, w, h):
        var p = Main.g.amB('paper-${id}');
        rb.blitAlphaRect(p, x, y, (p.width - w) >> 1, (p.height - h) >> 1, w, h);
        case Bitmap(b, x, y):
        rb.blitAlpha(b, x, y);
      }
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
              case _ if (room.state.pov[vi] == -1): " ";
              case Solid: Text.tp(room.state.pov[vi]) + "#" + Text.tr;
              case _: " ";
            } ]
        ];
      for (e in room.state.entities) {
        var mi = room.state.indexTile(e.x, e.y);
        if (switch (e.povType) {
            case Always: true;
            case Fade if (room.state.pov[mi] >= 0): true;
            case Hide if (room.state.pov[mi] > 0): true;
            case _: false;
          }) e.print(str, room.state.pov[mi]);
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
    if (room.state.visited) {
      room.x.target(room.tx, 19);
      room.y.target(room.ty, 19);
      room.z.target(room.tz, 29);
    }
    var rx = room.x.floor() - camX.floor();
    var ry = room.y.floor() - room.z.floor() - camY.floor();
    if (rx < Main.W && ry < Main.H
        && rx >= -ROOM_SIZE * room.state.width && ry >= -ROOM_SIZE * room.state.height) {
      ab.blitAlpha(cacheBg[room.state.id], rx, ry);
      ab.blitAlpha(cacheText[room.state.id].res, rx, ry);
    }
    if (room.state == state.mouseRoom) {
      ab.set(rx + state.mouseX, ry + state.mouseY, Colour.BLUE);
    }
  }
}
