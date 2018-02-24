import sk.thenet.app.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;
import lib.*;

using sk.thenet.FM;
using sk.thenet.stream.Stream;

class Main extends Application {
  public static var g:Game;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("", 800, 600))
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap("paper", "png/paper.png")
            ,Embed.getBitmap(font.FontFancy8x13.ASSET_ID, "png/fancy8x13.png")
            ,new AssetBind([
                "paper", font.FontFancy8x13.ASSET_ID
              ], (am, _) -> {
                Pal.init(am);
                Text.init(am);
                Renderer.init(am);
                false;
              })
          ])
        ,Keyboard
        ,Mouse
      ]);
    preloader = new TNPreloader(this, "game", true);
    addState(g = new Game(this));
    mainLoop();
  }
}
