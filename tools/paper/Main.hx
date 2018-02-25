import sk.thenet.app.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;
using sk.thenet.stream.Stream;

class Main extends Application {
  var p:Paper;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("", 300, 200))
        ,Surface(300, 200, 0)
        ,Assets([
             Embed.getBitmap("paper", "../../png/paper.png")
            ,Embed.getBitmap("alien", "../../paper-raw/alien-thumb.png")
            ,Embed.getBitmap("bunker", "../../paper-raw/bunker-thumb.png")
            ,Embed.getBitmap("eye", "../../paper-raw/eye-thumb.png")
            ,Embed.getBitmap("plane", "../../paper-raw/plane-thumb.png")
            ,Embed.getBitmap("rig", "../../paper-raw/rig-thumb.png")
            ,Embed.getBitmap("sub", "../../paper-raw/sub-thumb.png")
            ,Embed.getBitmap("toxic", "../../paper-raw/toxic-thumb.png")
            ,Embed.getBitmap("ufo", "../../paper-raw/ufo-thumb.png")
            ,new AssetBind(["alien", "bunker", "eye", "plane", "rig", "sub", "toxic", "ufo"], (am, _) -> {
                p.doIt();
                false;
              })
          ])
      ]);
    addState(p = new Paper(this));
    mainLoop();
  }
}

class Paper extends JamState {
  public function new(app) super("paper", app);
  
  public function doIt() {
    var s = amB("paper").fluent;
    var sv = s.getVector();
    var mat = OrderedDither.BAYER_16.map(n -> n / 256);
    var png = new sk.thenet.format.bmp.PNG();
    var pal = [ for (i in 0...11) sv[i * 4] ];
    for (photo in ["alien", "bunker", "eye", "plane", "rig", "sub", "toxic", "ufo"]) {
      var src = amB(photo);
      var srcv = src.getVector();
      var res = Platform.createBitmap(src.width, src.height, 0);
      var vi = 0;
      for (y in 0...src.height) for (x in 0...src.width) {
        var hsl = srcv[vi].toHSL();
        if ((x + y) % 2 == 0) hsl.l += 0.3;
        hsl.l += mat[x % 16 + (y % 16) * 16] * 0.1; // - 0.5;
        res.set(x, y, pal[10 - (hsl.l * 7).floor().minI(7)]);
        vi++;
      }
      sys.io.File.saveBytes('../../paper/${photo}.png', png.encode(res));
    }
    Sys.exit(0);
  }
}
