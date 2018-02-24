package lib;

class Text {
  public static var fonts:Array<Font>;
  public static inline var REG = FontType.Mono4;
  public static inline var tr = t(REG);
  static var tmp:Bitmap = Platform.createBitmap(200, 1, 0);
  
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
  
  public static inline function tp(pov:Int):String {
    return t(FontType.Mono5 - ((pov / 20).floor().minI(4)));
  }
  
  public static inline function t(ft:FontType):String {
    return "$" + String.fromCharCode("A".code + ft);
  }
  
  public static function render(
    ab:Bitmap, tx:Int, ty:Int, text:String, ?initial:FontType = Regular
  ):Void {
    fonts[initial].render(ab, tx, ty, text, fonts);
  }
  
  public static function justify(txt:String, width:Int):{
    res:Bitmap, marks:Array<Point2DI>
  } {
    var words = txt.split(" ").map(w -> {
         txt: w
        ,width: fonts[0].render(tmp, 0, 0, w, fonts).x
      });
    var lines = [];
    var lineWidths = [];
    var marks = [];
    var lineWords = [];
    var lineWidth = 0;
    var minSpace = width * 0.1;
    while (words.length > 0) {
      var curWord = words.shift();
      if (width - (curWord.width + lineWidth) >= minSpace) {
        lineWords.push(curWord);
        lineWidth += curWord.width;
      } else {
        lines.push(lineWords);
        lineWidths.push(lineWidth);
        lineWords = [curWord];
        lineWidth = curWord.width;
      }
    }
    var res = Platform.createBitmap(width, lines.length * 15, 0);
    var cy = 0;
    for (l in lines) {
      var spacing = (width - lineWidths.shift()) / l.length;
      var cx = 0.0;
      for (w in l) {
        fonts[0].render(res, cx.floor(), cy, w.txt, fonts);
        cx += w.width + spacing;
      }
      cy += 15;
    }
    return {res: res, marks: marks};
  }
}
