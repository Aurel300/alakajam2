package lib;

import lib.Story.Agent;
import lib.Story.Event;
import lib.Story.Place;
import lib.Story.PlotPoint;

class Procgen {
  static inline var MG_SIZE:Int = 50 * 16;
  
  public static function createScenario():Scenario {
    var ret = new Scenario();
    ret.story = createStory();
    ret.floors = [createLayout(3, ret.story)];
    return ret;
  }
  
  public static function createStory():Story {
    var story = new Story();
    function faction(t:String):Array<Agent> {
      return [ for (a in Story.ALL_AGENTS) if (a.factions.indexOf(t) != -1) a ];
    }
    function place(t:String):Array<Place> {
      return [ for (a in Story.ALL_PLACES) if (a.type.indexOf(t) != -1) a ];
    }
    function event(t:String):Event {
      for (a in Story.ALL_EVENTS) if (a.id == t) return a;
      return null;
    }
    function plot(event:Event):PlotPoint {
      return {
           time: 0
          ,canonical: true
          ,event: event
          ,agents: [ for (t in (event.agents != null ? event.agents.keys() : [].iterator()))
              t => FM.prng.nextElement(faction(event.agents[t]))
            ]
          ,places: [ for (t in (event.places != null ? event.places.keys() : [].iterator()))
              t => FM.prng.nextElement(place(event.places[t]))
            ]
          ,after: []
          ,before: []
        };
    }
    var pps = [];
    function plotBefore(a:PlotPoint, b:Event):PlotPoint {
      if (b == null) return null;
      var pp = plot(b);
      pp.before = [a];
      a.after.push(pp);
      pps.unshift(pp);
      return pp;
    }
    function plotAfter(a:PlotPoint, b:Event):PlotPoint {
      if (b == null) return null;
      var pp = plot(b);
      pp.after = [a];
      a.before.push(pp);
      pps.push(pp);
      return pp;
    }
    var root = plot(FM.prng.nextElement(Story.ALL_EVENTS));
    pps.push(root);
    var head = root;
    var tail = root;
    var events = 0;
    while (events < 5) {
      if (head.event.after != null && head.event.after.length > 0)
        head = plotBefore(head, event(FM.prng.nextElement(head.event.after)));
      if (tail.event.before != null && tail.event.before.length > 0)
        tail = plotAfter(tail, event(FM.prng.nextElement(tail.event.before)));
      events++;
    }
    story.plotpoints = pps;
    story.timeline = root;
    story.describe(story.plotpoints, -1, Dubious);
    return story;
  }
  
  public static function createLayout(storyRooms:Int, story:Story):Layout {
    var roomCount = (storyRooms + storyRooms * (1.5 + FM.prng.nextFloat())).floor();
    var minSide = Math.sqrt(roomCount).floor() + 1;
    var varSide = FM.prng.nextMod(minSide >> 1);
    var w = minSide + varSide;
    var h = minSide + ((minSide >> 1) - varSide);
    var grid = [ for (y in 0...h) for (x in 0...w) -1 ];
    inline function idx(x:Int, y:Int) return x + y * w;
    grid[idx(FM.prng.nextMod(w), FM.prng.nextMod(h))] = 0;
    var order = [ for (r in 1...roomCount) {
        var pos = [];
        var gi = 0;
        for (y in 0...h) for (x in 0...w) {
          if (grid[gi] == -1
              && ((x > 0 && grid[gi - 1] != -1)
                  || (x < w - 1 && grid[gi + 1] != -1)
                  || (y > 0 && grid[gi - w] != -1)
                  || (y < h - 1 && grid[gi + w] != -1))) pos.push(gi);
          gi++;
        }
        var nxt = FM.prng.nextElement(pos);
        grid[nxt] = r;
        nxt;
      } ];
    var storyIndices = [ for (i in 0...roomCount) i ];
    while (storyIndices.length > storyRooms) {
      storyIndices.splice(FM.prng.nextMod(storyIndices.length), 1);
    }
    var ret = new Layout();
    var maxW = [ for (x in 0...w) 0 ];
    var maxH = [ for (y in 0...h) 0 ];
    var states = [ for (n in order) {
        var nx = n % w;
        var ny = (n / h).floor();
        var rstate = createRoom(storyIndices.indexOf(n) != -1 ? Clipping : Normal, story);
        if (rstate.width > maxW[nx]) maxW[nx] = rstate.width;
        if (rstate.height > maxH[ny]) maxH[ny] = rstate.height;
        {x: nx, y: ny, state: rstate};
      } ];
    trace(maxW);
    var colRx = 0;
    var colRy = 0;
    var colX = [ for (x in 1...w) colRx += maxW[x - 1] ];
    var colY = [ for (y in 1...h) colRy += maxH[y - 1] ];
    colX.unshift(0);
    trace(colX);
    colY.unshift(0);
    for (s in states) {
      ret.rooms.push({
           state: s.state
          ,x: colX[s.x] * Renderer.ROOM_SIZE
          ,y: colY[s.y] * Renderer.ROOM_SIZE
          ,z: 0
          ,tx: colX[s.x] * Renderer.ROOM_SIZE
          ,ty: colY[s.y] * Renderer.ROOM_SIZE
          ,tz: 0
        });
    }
    ret.rooms[0].state.tapes.push(new Tape(ret.rooms[0].state, ret.rooms[1].state));
    ret.rooms[0].state.tapes[0].fromX = 3;
    ret.rooms[0].state.tapes[0].fromY = 2;
    ret.rooms[0].state.tapes[0].length = -10;
    ret.rooms[0].state.tapes[0].vertical = true;
    return ret;
  }
  
  public static function createRoom(type:RoomType, story:Story):RoomState {
    return (switch (type) {
        case Normal:
        new RoomState(type, 14, 4);
        case Clipping:
        new RoomState(type, 19, 5);
      });
  }
}
