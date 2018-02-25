package lib;

class Pal {
  public static var paper:Array<Colour>;
  public static var item:Array<Colour>;
  
  public static function init(am:AssetManager):Void {
    var s = am.getBitmap("paper");
    paper = [ for (i in 0...11) s.get(i * 4, 0) ];
    item = [ for (i in 0...5) s.get(48 + i * 4, 0) ];
  }
}
