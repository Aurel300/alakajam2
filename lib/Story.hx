package lib;

class Story {
  public static var ALL_AGENTS = [{
      id: "gov", display: [
           {text: "Government", plural: false, formal: 1}
          ,{text: "Gov", plural: true, formal: 0}
          ,{text: "White House", plural: false, formal: 1}
          ,{text: "Pigs", plural: true, formal: -1}
          ,{text: "Suits", plural: true, formal: 0}
          ,{text: "Fed", plural: true, formal: 0}
        ], factions: ["official"]
    }, {
      id: "alien", display: [
           {text: "Aliens", plural: true, formal: 0}
          ,{text: "Little Green Men", plural: true, formal: -1}
          ,{text: "Extra-terrestrials", plural: true, formal: 1}
          ,{text: "Unidentified Lifeforms", plural: true, formal: 1}
          ,{text: "The Flatwoods Monster", plural: false, formal: 0}
        ], factions: ["hidden", "alien"]
    }, {
      id: "media", display: [
           {text: "Media", plural: true, formal: 1}
          ,{text: "News Corporations", plural: true, formal: 1}
          ,{text: "Brainwashers", plural: true, formal: -1}
          ,{text: "TV", plural: false, formal: 0}
        ], factions: ["official"]
    }, {
      id: "army", display: [
           {text: "Army", plural: false, formal: 1}
          ,{text: "Military", plural: false, formal: 1}
          ,{text: "Green Army Men", plural: true, formal: -1}
          ,{text: "GI Joes", plural: true, formal: -1}
        ], factions: ["official"]
    }, {
      id: "citizen", display: [
           {text: "citizen", plural: false, formal: 1}
          ,{text: "inhabitant", plural: false, formal: 0}
          ,{text: "man (22)", plural: false, formal: 0}
          ,{text: "man (32)", plural: false, formal: 0}
          ,{text: "man (42)", plural: false, formal: 0}
          ,{text: "man (37)", plural: false, formal: 0}
          ,{text: "man (68)", plural: false, formal: 0}
          ,{text: "man (30)", plural: false, formal: 0}
          ,{text: "woman (22)", plural: false, formal: 0}
          ,{text: "woman (32)", plural: false, formal: 0}
          ,{text: "woman (42)", plural: false, formal: 0}
          ,{text: "woman (37)", plural: false, formal: 0}
          ,{text: "woman (68)", plural: false, formal: 0}
          ,{text: "woman (30)", plural: false, formal: 0}
          ,{text: "girl", plural: false, formal: 0}
          ,{text: "boy", plural: false, formal: 0}
          ,{text: "child", plural: false, formal: 0}
        ], factions: ["people"]
    }];
  
  public static var ALL_EVENTS:Array<Event> = [{
       id: "ufo-abduction"
      ,display: "%agent% claim~(agent/s/) to have been abducted by %alien%"
      ,agents: ["agent" => "people", "alien" => "alien"]
      ,before: ["ufo-sighting", "ufo-crash"]
    }, {
       id: "ufo-remote-contact"
      ,display: "%agent% claim~(agent/s/) to have evidence of alien contact"
      ,agents: ["agent" => "people"]
      ,before: ["ufo-sighting", "ufo-crash"]
    }, {
       id: "ufo-sighting"
      ,display: "/(a UFO was/a flying saucer was/an unknown object was/strange lights were) seen in the night sky?( by %agent%)"
      ,agents: ["agent" => "people"]
      ,after: ["ufo-remote-contact", "ufo-abduction"]
      ,before: ["ufo-crash"]
    }, {
       id: "ufo-plane"
      ,display: "%army% claim~(army/s/) strange lights are just top secret prototype planes"
      ,agents: ["army" => "army"]
      ,photo: "plane"
      ,after: ["ufo-sighting"]
      ,before: ["plane-attack"]
    }, {
       id: "ufo-crash"
      ,display: "a UFO crashed?( at %site%)"
      ,photo: "ufo"
      ,places: ["site" => "crashsite"]
      ,after: ["ufo-sighting", "ufo-remote-contact"]
      ,before: ["ufo-autopsy", "ufo-close-contact"]
    }, {
       id: "ufo-close-contact"
      ,display: "%agent% claim~(agent/s/) to have a clear tape recording of %alien%"
      ,agents: ["agent" => "people", "alien" => "alien"]
      ,after: ["ufo-crash"]
      ,before: ["ufo-autopsy"]
    }, {
       id: "ufo-autopsy"
      ,display: "%agent% ~(agent/has/have) a recording of autopsy on %alien% at %site%"
      ,photo: "alien"
      ,agents: ["agent" => "people", "alien" => "alien"]
      ,places: ["site" => "autopsy"]
      ,after: ["ufo-close-contact"]
    }, {
       id: "sub-seen"
      ,display: "%army% ~(army/is/are) using the sea to hide ~(army/its/their) submarines"
      ,photo: "sub"
      ,agents: ["army" => "army"]
      ,before: ["sub-toxic"]
    }, {
       id: "sub-toxic"
      ,display: "toxic waste left by submarines"
      ,photo: "toxic"
      ,after: ["sub-seen"]
    }, {
       id: "bunker"
      ,display: "%people% ~(people/is/are) hiding in a bunker?( at %site%)"
      ,photo: "bunker"
      ,agents: ["army" => "army"]
      ,places: ["site" => "crashsite"]
      ,after: ["sub-seen"]
    }, {
       id: "plane-attack"
      ,display: "autonomous plane abducted by aliens, ~(people/says/say) %people%"
      ,photo: "plane"
      ,agents: ["people" => "media"]
      ,after: ["ufo-places"]
      ,before: ["ufo-abduction", "plane-rig"]
    }, {
       id: "plane-rig"
      ,display: "oil mining rig is actually a top secret military plane prototype"
      ,photo: "rig"
      ,after: ["plane-attack"]
    }];
  
  public static var ALL_PLACES:Array<Place> = [
       {id: "roswell", display: "Roswell", type: ["crashsite", "autopsy"]}
      ,{id: "area51", display: "Area 51", type: ["crashsite", "autopsy"]}
    ];
  
  public static var FILLER = [
       "This is not to say that the theories are confirmed."
      ,"Could this be true?"
      ,"We need to investigate further."
      ,"Suspicious indeed!"
      ,"Who could be behind this?"
      ,"This kind of journalism is indicative of declining quality of schools."
      ,"But why?"
      ,"Does the plot in fact, as they say, thicken?"
      ,"Who is responsible for all of this?"
      ,"Well, well."
      ,"What a story!"
    ];
  
  public var plotpoints:Array<PlotPoint>;
  public var timeline:PlotPoint;
  
  public function new() {}
  
  public function excerpt():{txt:String, photo:String} {
    var root = FM.prng.nextElement(plotpoints);
    var pp = [root];
    if (FM.prng.nextMod(3) == 0 && root.after.length > 0) pp.unshift(FM.prng.nextElement(root.after));
    if (FM.prng.nextMod(3) == 0 && root.before.length > 0) pp.push(FM.prng.nextElement(root.before));
    return {txt: describe(pp, FM.prng.nextMod(2), Chance.ch(30) ? Chance.el([Dubious, Contrast]) : Normal), photo: root.event.photo};
  }
  
  public function describe(
    plotpoints:Array<PlotPoint>, formal:Int, mode:DescribeMode
  ):String {
    var pi = -1;
    var text = [ for (p in plotpoints) {
        pi++;
        describePlotPoint(p, formal, switch (mode) {
            case Normal: switch (FM.prng.nextMod(10)) {
                case 0: "Apparently, ";
                case 1: "We can confirm that ";
                case 2 if (pi != 0): "Also, ";
                case 2: "First and foremost, ";
                case 3: "Well, ";
                case _: "";
              };
            case Dubious: switch (FM.prng.nextMod(10)) {
                case 0: "Apparently, ";
                case 1: "Some claim that ";
                case 2 if (pi != 0): "Also, ";
                case 3: "Some sources claim that ";
                case 4: "There is almost no evidence that ";
                case _: "";
              };
            case Contrast: switch (FM.prng.nextMod(10)) {
                case 0 if (pi == 0): "But then why is it that ";
                case 1 if (pi == 0): "However, ";
                case 2 if (pi == 0): "But, ";
                case 3 if (pi == 0): "If this is so, how to explain that ";
                case 0: "Apparently, ";
                case 1: "Clearly, ";
                case 2: "Also, ";
                case 3: "Very importantly, ";
                case _: "";
              };
          });
      } ];
    for (i in 0...text.length) {
      if (FM.prng.nextBool())
        text.insert(FM.prng.nextMod(text.length), FM.prng.nextElement(FILLER));
    }
    return text.join(" ");
  }
  
  public function describePlotPoint(
    pp:PlotPoint, formal:Int, prefix:String
  ):String {
    var ret = new StringBuf();
    var ci = 0;
    var rep = pp.event.display;
    var plurals = new Map<String, Bool>();
    ret.add(prefix);
    while (ci < rep.length) {
      function takeParens():String {
        var ret = new StringBuf();
        ci++;
        while (ci < rep.length) {
          switch (rep.charAt(ci)) {
            case "(":
            case ")": break;
            case _: ret.add(rep.charAt(ci));
          }
          ci++;
        }
        return ret.toString();
      }
      switch (rep.charAt(ci)) {
        case "/": ret.add(FM.prng.nextElement(takeParens().split("/")));
        case "?": var opt = takeParens(); if (FM.prng.nextBool()) ret.add(opt);
        case "~": var pl = takeParens().split("/"); ret.add(pl[plurals[pl[0]] ? 2 : 1]);
        case _: ret.add(rep.charAt(ci));
      }
      ci++;
    }
    var rets = ret.toString();
    for (a in pp.agents.keys()) {
      var ap = FM.prng.nextElement(pp.agents[a].display.filter(
          d -> d.formal == formal || d.formal == 0
        ));
      plurals[a] = ap.plural;
      rets = rets.replace('%${a}%', ap.text);
    }
    for (a in pp.places.keys()) {
      rets = rets.replace('%${a}%', pp.places[a].display);
    }
    if (Chance.ch(8)) {
      var t = '19${70 + pp.time}';
      rets += Chance.el([
         " at " + t
        ,", " + t
        ,", found in documents from " + t
        ,", are we doomed to relive the events of " + t + "? We can only wait"
        ,". It's " + t + " all over again "
        ,", so typical of " + t]);
    }
    rets += (switch (FM.prng.nextMod(4)) {
        case 0: "!";
        case 1: "...";
        case _: ".";
      });
    rets = rets.charAt(0).toUpperCase() + rets.substr(1);
    return rets;
  }
}

typedef Agent = {
     id:String
    ,display:Array<{text:String, plural:Bool, formal:Int}>
    ,factions:Array<String>
  };

typedef Event = {
     id:String
    ,display:String
    ,?photo:String
    ,?agents:Map<String, String>
    ,?places:Map<String, String>
    ,?after:Array<String>
    ,?before:Array<String>
  };

typedef Place = {
     id:String
    ,display:String
    ,type:Array<String>
  };

typedef PlotPoint = {
     time:Int
    ,canonical:Bool
    ,event:Event
    ,agents:Map<String, Agent>
    ,places:Map<String, Place>
    ,after:Array<PlotPoint>
    ,before:Array<PlotPoint>
  };

enum DescribeMode {
  Normal;
  Dubious;
  Contrast;
}
