package lib;

class Item {
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
          ,"Steel-toe Boots"
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
  
  public static function drop():Item {
    function el(a:Array<String>):String return FM.prng.nextElement(a);
    function el2(a:Array<String>):String {
      var total = (0.75) * a.length;
      var step = 0.5 / a.length;
      var cur = 1.0;
      var curTotal = 0.0;
      var chosen = FM.prng.nextFloat(total);
      for (el in a) {
        curTotal += cur;
        if (chosen < curTotal) return el;
        cur -= step;
      }
      return a[0];
    }
    function ch(chance:Int):Bool return FM.prng.nextMod(100) < chance;
    function n(min:Int, max:Int):Int return min + FM.prng.nextMod(max + 1 - min);
    function n2(min:Int, max:Int):Int return min + (FM.prng.nextFloat() * FM.prng.nextFloat() * (max + 1 - min)).floor();
    var type = el([
         "weapon", "armour-head", "armour-shoulder", "armour-torso"
        ,"armour-hand", "armour-legs", "armour-feet", "armour-finger", "food"
      ]);
    var ret = new Item();
    ret.name = ret.baseName = el2(NAMES[type]);
    if (ch(80)) ret.name = el(ADJECTIVES) + " " + ret.name;
    if (ch(80)) ret.name = ret.name + " " + el(MODIFIERS);
    ret.weight = n(5, 25);
    ret.type = (switch (type) {
        case "weapon": Weapon(n2(5, 100), 25 - n2(5, 20), ch(10) ? n(1, 3) : 0, ch(5) ? 1 : 0);
        case _.startsWith("armour") => true:
        Armour(switch (type) {
            case "armour-head":  Head;
            case "armour-shoulder": Shoulder;
            case "armour-torso": Torso;
            case "armour-hand": Hand;
            case "armour-legs": Legs;
            case "armour-feet": Feet;
            case "armour-finger" | _: Finger;
          }, n2(5, 80), ch(10) ? n(1, 5) : 0);
        case "food" | _: Food(n(5, 90), ch(5) ? n(1, 9) : 0, ch(5) ? n(5, 10) : 0);
      });
    return ret;
  }
  
  public var type:ItemType;
  public var name:String;
  public var baseName:String;
  public var weight:Int;
  
  public function price():Int {
    var base = 5.0;
    switch (type) {
      case Weapon(dmg, rate, stun, push):
      base += dmg * 2;
      base += 50 - rate * 3;
      base += stun * 10;
      base += push * 20;
      case Armour(_, def, thorn):
      base += def * 1.5;
      base += thorn * 4;
      case Food(heal, toxic, poison):
      base += heal;
      base -= toxic * 2.0;
      base -= poison * 2.5;
    }
    base -= weight * 0.2;
    return base.floor().minI(1);
  }
  
  public function new() {}
}
