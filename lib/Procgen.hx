package lib;

import lib.Story.Agent;
import lib.Story.Event;
import lib.Story.Place;
import lib.Story.PlotPoint;

using lib.Chance;

class Procgen {
  static inline var MG_SIZE:Int = 50 * 16;
  
  public static function createScenario():Array<{text:String, work:Void->Bool, ?next:String}> {
    var ret = new Scenario();
    ret.floors = [];
    return ([
        {text: "Generating story...", work: () -> { ret.story = createStory(); return true; }}
      ]:Array<{text:String, work:Void->Bool, ?next:String}>).concat([ for (i in 0...6)
        {text: 'Generating floors ${i + 1} / 6...', work: () -> { ret.floors[i] = createLayout(3 + Chance.n(0, i), ret.story); return true; }}
      ]).concat([
        {text: 'Starting game...', work: () -> { Main.g.state.loadScenario(ret); return true; }, next: "game"}
      ]);
  }
  
  static var ADJECTIVES = [
       "Normal"
      ,"Basic"
      ,"Suspicious"
      ,"Dangerous"
      ,"Mysterious"
      ,"Odorous"
      ,"Fancy"
      ,"Extra-terrestrial"
      ,"Weird"
      ,"Cool"
      ,"Hi-tech"
      ,"Red"
      ,"Blue"
      ,"Green"
      ,"Yellow"
      ,"Cyan"
      ,"Magenta"
      ,"White"
      ,"Black"
      ,"Modest"
      ,"Arrogant"
      ,"Proud"
      ,"Shy"
      ,"Official"
      ,"Warm"
      ,"Cold"
      ,"Long"
    ];
  static var MODIFIERS = [
       "of Doom"
      ,"3000"
      ,"9000"
      ,"9001"
      ,"30k"
      ,"of Power"
      ,"of Magic"
      ,"of Coolness"
      ,"with Googly Eyes"
      ,"with a Silver Finish"
      ,"found in a Crater"
      ,"as Seen on TV"
      ,"as Heard of on Radio"
      ,"in a Box"
      ,"in Original Wrapping"
      ,"with a Copper Taste"
      ,"with a Lead Taste"
      ,"with a Platinum Taste"
      ,"with a Plastic Taste"
    ];
  static var NAMES = [
      "weapon" => [
           "Sword"
          ,"Dagger"
          ,"Knife"
          ,"Swiss Knife"
          ,"Truncheon"
          ,"Stick"
          ,"Club"
          ,"Pipe"
          ,"Hammer"
          ,"Attack Fridge"
          ,"Attack Chair"
        ]
      ,"armour-head" => [
           "Helmet"
          ,"Cap"
          ,"Hat"
          ,"Baseball Cap"
          ,"Winter Hat"
          ,"Sombrero"
          ,"Fedora"
          ,"Straw Hat"
          ,"Ushanka"
          ,"Visor"
          ,"Tinfoil Hat"
          ,"Welding Mask"
        ]
      ,"armour-shoulder" => [
           "Shoulder Pad"
          ,"Epaulette"
          ,"Shoulder Badge"
        ]
      ,"armour-torso" => [
           "Shirt"
          ,"Chainmail"
          ,"Mainchail"
          ,"Jacket"
          ,"Tank Top"
          ,"Treaded Tank Top"
          ,"T-Shirt"
          ,"Sweater"
          ,"Sweatshirt"
          ,"Pyjama Shirt"
        ]
      ,"armour-hand" => [
           "Glove"
          ,"Kitchen Mitt"
          ,"Baseball Glove"
          ,"Gauntlet"
          ,"Skateboard Glove"
          ,"Handsock"
        ]
      ,"armour-legs" => [
           "Trousers"
          ,"Pants"
          ,"Kilt"
          ,"Skirt"
          ,"Tutu"
          ,"Jeans"
          ,"Shorts"
          ,"Cargo Pants"
          ,"Pyjama Pants"
        ]
      ,"armour-feet" => [
           "Shoes"
          ,"Boots"
          ,"Stilettos"
          ,"Steel-toed Boots"
          ,"Sandals"
          ,"Flip Flops"
          ,"Crocs"
          ,"Skis"
          ,"Snowboard Boots"
          ,"Tennis Shoes"
          ,"Winged Shoes"
        ]
      ,"armour-finger" => [
           "Ring"
          ,"Ringlet"
          ,"Finger Decoration"
          ,"Boxer"
          ,"Bracelet"
          ,"Friendship Charm"
        ]
      ,"food" => [
           "Sandwich"
          ,"Meal"
          ,"Instant Noodles"
          ,"Cup Noodles"
          ,"Ramen"
          ,"Frozen Pizza"
          ,"Fish"
          ,"Tin of Sardines"
          ,"Sushi"
          ,"Sashimi"
          ,"Burger"
          ,"Chicken"
          ,"Nugget"
          ,"Riceball"
          ,"Soup"
          ,"Cinnamon Roll"
          ,"Takeaway Pizza"
          ,"Pie"
          ,"Strudel"
          ,"Snack"
          ,"Energy Bar"
          ,"Crisps"
          ,"Bottle of Water"
          ,"Carton of Milk"
          ,"Stick of Butter"
        ]
    ];
  
  public static function createItem():Item {
    var type = [
         "weapon", "armour", "food"
      ].el();
    if (type == "armour") type = [
         "armour-head", "armour-shoulder", "armour-torso"
        ,"armour-hand", "armour-legs", "armour-feet", "armour-finger"
      ].el();
    var ret = new Item();
    ret.name = ret.baseName = NAMES[type].el2();
    if (Chance.ch(80)) ret.name = ADJECTIVES.el() + " " + ret.name;
    if (Chance.ch(80)) ret.name = ret.name + " " + MODIFIERS.el();
    ret.weight = Chance.n(5, 25);
    ret.type = (switch (type) {
        case "weapon": Weapon(Chance.n2(5, 100), 25 - Chance.n2(5, 20), Chance.ch(10) ? Chance.n(1, 15) : 0, Chance.ch(5) ? 1 : 0);
        case _.startsWith("armour") => true:
        Armour(switch (type) {
            case "armour-head":  Head;
            case "armour-shoulder": Shoulder;
            case "armour-torso": Torso;
            case "armour-hand": Hand;
            case "armour-legs": Legs;
            case "armour-feet": Feet;
            case "armour-finger" | _: Finger;
          }, Chance.n2(5, 80), Chance.ch(10) ? Chance.n(1, 5) : 0);
        case "food" | _: Food(Chance.n(5, 90), Chance.ch(5) ? Chance.n(1, 9) : 0, Chance.ch(5) ? Chance.n(5, 10) : 0);
      });
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
    var initial = idx(FM.prng.nextMod(w), FM.prng.nextMod(h));
    grid[initial] = 0;
    var order = [ for (r in 1...roomCount) {
        var pos = [];
        var gi = 0;
        for (y in 0...h) for (x in 0...w) {
          var from = [
               (gi - 1) => false
              ,(gi + 1) => false
              ,(gi - w) => false
              ,(gi + w) => false
            ];
          if (grid[gi] == -1
              && ((x > 0 && grid[gi - 1] != -1 && { from[gi - 1] = true; })
                  || (x < w - 1 && grid[gi + 1] != -1 && { from[gi + 1] = true; })
                  || (y > 0 && grid[gi - w] != -1 && { from[gi - w] = true; })
                  || (y < h - 1 && grid[gi + w] != -1 && { from[gi + w] = true; })))
            pos.push({pos: gi, from: from});
          gi++;
        }
        var nxt = FM.prng.nextElement(pos);
        grid[nxt.pos] = r;
        {at: nxt.pos, r: r, from: FM.prng.nextElement([ for (k in nxt.from.keys()) if (nxt.from[k]) k ])};
      } ];
    order.unshift({at: initial, r: 0, from: -1});
    var final = roomCount - 1;
    var storyIndices = [ for (i in 0...roomCount - 1) i ];
    while (storyIndices.length > storyRooms) {
      storyIndices.splice(FM.prng.nextMod(storyIndices.length), 1);
    }
    var ret = new Layout();
    var maxW = [ for (x in 0...w) 0 ];
    var maxH = [ for (y in 0...h) 0 ];
    var minW = [ for (x in 0...w) 50 ];
    var minH = [ for (y in 0...h) 50 ];
    var gridStates = new Map<Int, RoomState>();
    var states = [ for (n in order) {
        var nx = n.at % w;
        var ny = (n.at / w).floor();
        var rtype = Chance.el([RoomType.Normal, RoomType.Light]);
        if (storyIndices.indexOf(n.r) != -1) rtype = Clipping;
        if (n.r == final) rtype = Exit;
        var rstate = createRoom(rtype, story);
        if (rstate.type != Clipping && rstate.title == null) rstate.title = '${n.r + 1}';
        gridStates[n.at] = rstate;
        maxW[nx] = maxW[nx].maxI(rstate.width);
        maxH[ny] = maxH[ny].maxI(rstate.height);
        minW[nx] = minW[nx].minI(rstate.width);
        minH[ny] = minH[ny].minI(rstate.height);
        {from: n.from, at: n.at, x: nx, y: ny, state: rstate};
      } ];
    var colRx = 0;
    var colRy = 0;
    var colX = [ for (x in 1...w) colRx += maxW[x - 1] ];
    var colY = [ for (y in 1...h) colRy += maxH[y - 1] ];
    colX.unshift(0);
    colY.unshift(0);
    function placePlayer() {
      for (y in 2...states[0].state.h2 - 3) for (x in 2...states[0].state.w2 - 3) {
        if (states[0].state.walls[states[0].state.indexTile(x, y)] == WallType.None) {
          states[0].state.entities.push(new Player(x, y));
          return;
        }
      }
    }
    placePlayer();
    for (s in states) {
      var fox = 0;
      var foy = 0;
      if (s.from != -1) {
        var sfx = s.from % w;
        var sfy = (s.from / w).floor();
        fox = s.x - sfx;
        foy = s.y - sfy;
        var tape = new Tape(gridStates[s.from], s.state);
        tape.vertical = sfx == s.x;
        if (tape.vertical) {
          tape.fromX = 1 + FM.prng.nextMod(minW[s.x] * 2 - 5);
          if (s.from < s.at) {
            tape.fromY = gridStates[s.from].h2 - 3;
            tape.length = 6 + (maxH[sfy] - gridStates[s.from].height) * 2;
            gridStates[s.from].portWide(s.state, tape.fromX + 1, 2, tape.fromY + 1, 1, true);
          } else {
            tape.fromY = 1;
            tape.length = -(6 + (maxH[s.y] - s.state.height) * 2);
            gridStates[s.from].portWide(s.state, tape.fromX + 1, 2, 1, s.state.h2 - 2, false);
          }
        } else {
          tape.fromY = 1 + FM.prng.nextMod(minH[s.y] * 2 - 5);
          if (s.from < s.at) {
            tape.fromX = gridStates[s.from].w2 - 3;
            tape.length = 6 + (maxW[sfx] - gridStates[s.from].width) * 2;
            gridStates[s.from].portHigh(s.state, tape.fromY + 1, 2, tape.fromX + 1, 1, true);
          } else {
            tape.fromX = 1;
            tape.length = -(6 + (maxW[s.x] - s.state.width) * 2);
            gridStates[s.from].portHigh(s.state, tape.fromY + 1, 2, 1, s.state.w2 - 2, false);
          }
        }
        gridStates[s.from].tapes.push(tape);
      }
      ret.rooms.push({
           state: s.state
          ,x: colX[s.x] * Renderer.ROOM_SIZE + fox * Main.W
          ,y: colY[s.y] * Renderer.ROOM_SIZE + foy * Main.H
          ,z: 0
          ,tx: colX[s.x] * Renderer.ROOM_SIZE
          ,ty: colY[s.y] * Renderer.ROOM_SIZE
          ,tz: 0
        });
    }
    return ret;
  }
  
  static var INTERS = [
      {w: 7, h: 7, l: [
           1, 1, 1, 1, 0, 0, 0
          ,1, 1, 1, 1, 0, 0, 0
          ,1, 1, 1, 1, 0, 0, 0
          ,1, 1, 1, 1, 1, 0, 1
          ,0, 0, 0, 1, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 1, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           1, 1, 1, 1, 0, 0, 0
          ,1, 0, 0, 0, 0, 0, 0
          ,1, 0, 1, 1, 1, 0, 0
          ,1, 0, 1, 1, 1, 0, 1
          ,0, 0, 0, 1, 0, 0, 0
          ,0, 0, 0, 1, 0, 0, 0
          ,0, 0, 0, 1, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           1, 1, 1, 1, 0, 0, 0
          ,1, 0, 0, 0, 0, 0, 0
          ,1, 0, 1, 1, 0, 0, 0
          ,1, 0, 1, 1, 1, 0, 1
          ,0, 0, 0, 1, 1, 0, 1
          ,0, 0, 0, 0, 0, 0, 1
          ,0, 0, 0, 1, 1, 1, 1
        ]}
      ,{w: 7, h: 7, l: [
           0, 0, 0, 1, 1, 1, 1
          ,0, 0, 0, 0, 0, 0, 1
          ,0, 0, 0, 1, 1, 0, 1
          ,1, 0, 1, 1, 1, 0, 1
          ,1, 0, 1, 1, 0, 0, 0
          ,1, 0, 0, 0, 0, 0, 0
          ,1, 1, 1, 1, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           0, 0, 0, 0, 0, 0, 0
          ,0, 1, 1, 1, 1, 1, 0
          ,0, 1, 0, 0, 0, 1, 0
          ,0, 1, 0, 0, 0, 1, 0
          ,0, 1, 0, 0, 0, 1, 0
          ,0, 1, 1, 0, 1, 1, 0
          ,0, 0, 0, 0, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           0, 0, 0, 0, 0, 0, 0
          ,0, 1, 1, 0, 1, 1, 0
          ,0, 1, 0, 0, 0, 1, 0
          ,0, 1, 1, 1, 1, 1, 0
          ,0, 1, 0, 0, 0, 1, 0
          ,0, 1, 1, 0, 1, 1, 0
          ,0, 0, 0, 0, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           0, 1, 0, 0, 0, 0, 0
          ,0, 1, 0, 0, 0, 0, 0
          ,0, 1, 0, 0, 0, 0, 0
          ,0, 1, 1, 0, 1, 1, 0
          ,0, 0, 0, 0, 0, 1, 0
          ,0, 0, 0, 0, 0, 1, 0
          ,0, 0, 0, 0, 0, 1, 0
        ]}
      ,{w: 7, h: 7, l: [
           0, 0, 0, 0, 0, 1, 0
          ,0, 0, 0, 0, 0, 1, 0
          ,0, 0, 0, 0, 0, 1, 0
          ,0, 1, 1, 0, 1, 1, 0
          ,0, 1, 0, 0, 0, 0, 0
          ,0, 1, 0, 0, 0, 0, 0
          ,0, 1, 0, 0, 0, 0, 0
        ]}
      ,{w: 7, h: 7, l: [
           1, 1, 1, 1, 1, 0, 1
          ,1, 0, 0, 0, 0, 0, 1
          ,1, 0, 1, 1, 1, 0, 1
          ,1, 0, 1, 0, 1, 0, 1
          ,0, 0, 1, 0, 1, 0, 1
          ,1, 0, 0, 0, 1, 0, 1
          ,1, 1, 1, 1, 1, 0, 1
        ]}
      ,{w: 7, h: 7, l: [
           0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
          ,0, 0, 0, 0, 0, 0, 0
        ]}
      ,{w: 3, h: 3, l: [
           0, 0, 0
          ,0, 0, 0
          ,0, 0, 0
        ]}
      ,{w: 3, h: 3, l: [
           1, 1, 0
          ,0, 0, 0
          ,0, 1, 1
        ]}
      ,{w: 3, h: 3, l: [
           0, 1, 0
          ,0, 1, 0
          ,0, 0, 0
        ]}
    ];
  
  public static function createRoom(type:RoomType, story:Story):RoomState {
    return (switch (type) {
        case Normal | Light | CharSheet:
        var w = Chance.n(4, 8) + Chance.n2(2, 10);
        var h = Chance.n(4, 8) + Chance.n2(2, 10);
        var ret = new RoomState(type, w, h);
        w *= 2;
        h *= 2;
        w -= 4;
        h -= 4;
        var posint = Chance.el(INTERS.filter(i -> i.w <= w && i.h <= h));
        var posw = posint.w;
        var posh = posint.h;
        var posstate = posint.l.copy();
        while (posw < w || posh < h) {
          switch (Chance.el([].concat(posw < w ? [0] : []).concat(posh < h ? [1] : []))) {
            case 0: // w
            var x = Chance.n(0, posw - 1);
            for (i in 0...posh) {
              var ri = posh - 1 - i;
              posstate.insert(x + ri * posw, posstate[x + ri * posw]);
            }
            posw++;
            case _: // h
            var y = Chance.n(0, posh - 1);
            posstate = posstate.slice(0, y * posw).concat(posstate.slice(y * posw, (y + 1) * posw)).concat(posstate.slice(y * posw));
            posh++;
          }
        }
        ret.wallRect(posstate.map(n -> switch (n) {
            case 1: WallType.Solid;
            case _: WallType.None;
          }), 2, 2, w, h);
        var treasureCount = Chance.ch(8) ? Chance.n(1, 3) : 0;
        var enemyCount = Chance.ch(30) ? Chance.n2(3, 10) : 0;
        var empty = [ for (y in 0...posh) for (x in 0...posw) if (posstate[x + y * posw] != 1) {x: x, y: y} ];
        while (enemyCount > 0 && empty.length > 0) {
          var p = Chance.el(empty);
          empty.remove(p);
          ret.add(new Enemy("x", p.x + 2, p.y + 2));
          enemyCount--;
        }
        while (treasureCount > 0 && empty.length > 0) {
          var p = Chance.el(empty);
          empty.remove(p);
          if (Chance.ch(30)) ret.add(new ItemDrop(createItem(), p.x + 2, p.y + 2));
          else ret.add(new GoldDrop(Chance.n2(10, 120), p.x + 2, p.y + 2));
          treasureCount--;
        }
        return ret;
        case Clipping:
        var w = 8 + FM.prng.nextMod(12);
        var aw = w * Renderer.ROOM_SIZE - 18;
        var ah = 0;
        var photoH = 0;
        var excerpt = story.excerpt();
        if (excerpt.photo != null) {
          photoH = 140 + FM.prng.nextMod(60);
          ah += photoH;
        }
        excerpt.txt = [ for (w in excerpt.txt.split(" "))
            if (w.split("").filter(
                l -> l.charCodeAt(0) < "a".code || l.charCodeAt(0) > "z".code
              ).length == 0 && Chance.ch(10)) "$B" + w
            else if (Chance.ch(w.length * 3)) Text.c((w.length * .6).floor())
            else w
          ].join(" ");
        var justified = Text.justify(excerpt.txt, aw);
        ah += justified.res.height;
        var h = ((ah + 18) / Renderer.ROOM_SIZE).ceil();
        var ret = new RoomState(type, w, h);
        var cy = 9;
        if (excerpt.photo != null) {
          ret.visuals.push(Photo(excerpt.photo, 9, cy, aw, photoH));
          cy += photoH;
        }
        for (m in justified.marks) for (i in 0...m.txt.length) {
          var leten = new Enemy(
               m.txt.charAt(i)
              ,i + ((8 + m.pt.x) >> 3) + 1
              ,(((cy / 8).floor() * 8 + 4 + m.pt.y) >> 3) + 1
            );
          leten.pov = 0;
          leten.alarmed = false;
          ret.entities.push(leten);
        }
        ret.fix();
        ret.visuals.push(Bitmap(justified.res, 8, (cy / 8).floor() * 8 + 4));
        ret;
        case Exit:
        var ret = new RoomState(type, 5, 5);
        ret.title = "Exit";
        ret.walls[ret.indexTile(5, 5)] = ret.walls[ret.indexTile(4, 5)]
          = WallType.Trigger((player) -> { Main.g.state.nextLevel(); });
        ret.visuals.push(
            Text(Text.t(Mono1) + "[" + Text.t(Mono5) + "@@" + Text.t(Mono1) + "]", 23, 36)
          );
        return ret;
      });
  }
}
