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
        ,font.FontFancy8x13.initAuto(am, Pal.paper[8], Pal.paper[6], Pal.paper[4])
        ,font.FontNS.initAuto(am, Pal.paper[10], Pal.paper[6], Pal.paper[4])
        ,font.FontNS.initAuto(am, Pal.paper[8], Pal.paper[6], Pal.paper[4])
        ,font.FontSymbol8x13.init(am, Pal.paper[10], Pal.paper[6], null, 1, 0, 0, -5)
        ,font.FontFancy8x13.init(am, Pal.item[0], Pal.item[4], Pal.paper[3], 1, 0, 1, -4)
      ];
  }
  
  public static inline function tp(pov:Int):String {
    return t(FontType.Mono5 - ((pov / 20).floor().clampI(0, 4)));
  }
  
  public static inline function t(ft:FontType):String {
    return "$" + String.fromCharCode("A".code + ft);
  }
  
  public static inline function c(l:Int):String {
    return t(Symbol) + "G" + "".lpad("H", l) + "I";
  }
  
  public static function render(
    ab:Bitmap, tx:Int, ty:Int, text:String, ?initial:FontType = Regular
  ):Void {
    fonts[initial].render(ab, tx, ty, text, fonts);
  }
  
  public static function justify(txt:String, width:Int, ?ft:FontType = Regular):{
    res:Bitmap, marks:Array<{pt:Point2DI, txt:String}>
  } {
    var words = txt.split(" ").map(w -> {
         txt: w
        ,width: fonts[0].render(tmp, 0, 0, w, fonts).x + (w.startsWith("$B") ? 8 : 0)
        ,mono: w.startsWith("$B")
      });
    var lines = [];
    var lineWidths = [];
    var lineWords = [];
    var lineWidth = 0;
    var minSpace = width * 0.1;
    var maxSpacing = 20.0;
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
    if (lineWords.length > 0) {
      lines.push(lineWords);
      lineWidths.push(lineWidth);
    }
    var res = Platform.createBitmap(width, lines.length.maxI(1) * 16, 0);
    var marks = [];
    var cy = 0;
    for (l in lines) {
      var spacing = ((width - lineWidths.shift()) / (l.length - 1)).minF(maxSpacing);
      var cx = 0.0;
      for (w in l) {
        if (w.mono)
          marks.push({pt: new Point2DI((cx / 8).floor() * 8, cy), txt: w.txt.substr(2)});
        else
          fonts[0].render(
              res, cx.floor() + 1, cy, t(ft) + w.txt, fonts
            );
        cx += w.width + spacing;
      }
      cy += 16;
    }
    return {res: res, marks: marks};
  }
}
