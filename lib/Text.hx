package lib;

class Text {
  public static var fonts:Array<Font>;
  public static inline var REG = FontType.Mono4;
  public static inline var tr = t(REG);
  
  public static function init(am:AssetManager):Void {
    fonts = [
         font.FontFancy8x13.initAuto(am, Pal.paper[10], Pal.paper[6], Pal.paper[4])
        ,font.FontFancy8x13.init(am, Pal.paper[10], Pal.paper[6], Pal.paper[4], 1, 0, 1, -4)
        ,font.FontFancy8x13.init(am, Pal.paper[9], Pal.paper[6], Pal.paper[4], 1, 0, 1, -4)
        ,font.FontFancy8x13.init(am, Pal.paper[8], Pal.paper[6], Pal.paper[4], 1, 0, 1, -4)
        ,font.FontFancy8x13.init(am, Pal.paper[7], Pal.paper[6], Pal.paper[4], 1, 0, 1, -4)
        ,font.FontFancy8x13.init(am, Pal.paper[6], Pal.paper[6], Pal.paper[4], 1, 0, 1, -4)
      ];
  }
  
  public static inline function t(ft:FontType):String {
    return "$" + String.fromCharCode("A".code + ft);
  }
  
  public static function render(
    ab:Bitmap, tx:Int, ty:Int, text:String, ?initial:FontType = Regular
  ):Void {
    fonts[initial].render(ab, tx, ty, text, fonts);
  }
}
