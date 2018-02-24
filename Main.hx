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
            ,Embed.getBitmap("paper-alien", "paper/alien.png")
            ,Embed.getBitmap("paper-bunker", "paper/bunker.png")
            ,Embed.getBitmap("paper-plane", "paper/plane.png")
            ,Embed.getBitmap("paper-rig", "paper/rig.png")
            ,Embed.getBitmap("paper-sub", "paper/sub.png")
            ,Embed.getBitmap("paper-toxic", "paper/toxic.png")
            ,Embed.getBitmap("paper-ufo", "paper/ufo.png")
            ,new AssetBind([
                 "paper", font.FontFancy8x13.ASSET_ID
                ,"paper-alien"
                ,"paper-bunker"
                ,"paper-plane"
                ,"paper-rig"
                ,"paper-sub"
                ,"paper-toxic"
                ,"paper-ufo"
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
