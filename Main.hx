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
  public static inline var W:Int = 400;
  public static inline var H:Int = 300;
  public static inline var WH:Int = W >> 1;
  public static inline var HH:Int = H >> 1;
  
  public static var g:Game;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("", 800, 600))
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap("paper", "png/paper.png")
            ,Embed.getBitmap(font.FontFancy8x13.ASSET_ID, "png/fancy8x13.png")
            ,Embed.getBitmap(font.FontNS.ASSET_ID, "png/ns8x16.png")
            ,Embed.getBitmap(font.FontSymbol8x13.ASSET_ID, "png/symbol8x13.png")
            ,Embed.getBitmap("paper-alien", "paper/alien.png")
            ,Embed.getBitmap("paper-bunker", "paper/bunker.png")
            ,Embed.getBitmap("paper-eye", "paper/eye.png")
            ,Embed.getBitmap("paper-plane", "paper/plane.png")
            ,Embed.getBitmap("paper-rig", "paper/rig.png")
            ,Embed.getBitmap("paper-sub", "paper/sub.png")
            ,Embed.getBitmap("paper-toxic", "paper/toxic.png")
            ,Embed.getBitmap("paper-ufo", "paper/ufo.png")
            ,Embed.getSound("alert", "wav/alert.wav")
            ,Embed.getSound("chest", "wav/chest.wav")
            ,Embed.getSound("enemy-hurt", "wav/enemy-hurt.wav")
            ,Embed.getSound("equip", "wav/equip.wav")
            ,Embed.getSound("gold", "wav/gold.wav")
            ,Embed.getSound("heal", "wav/heal.wav")
            ,Embed.getSound("page", "wav/page.wav")
            ,Embed.getSound("pause", "wav/pause.wav")
            ,Embed.getSound("player-death", "wav/player-death.wav")
            ,Embed.getSound("player-hurt", "wav/player-hurt.wav")
            ,Embed.getSound("player-kill", "wav/player-kill.wav")
            ,Embed.getSound("player-step", "wav/player-step.wav")
            ,Embed.getSound("poison", "wav/poison.wav")
            ,Embed.getSound("unequip", "wav/unequip.wav")
            ,Embed.getSound("victory", "wav/victory.wav")
            ,Embed.getSound("vision", "wav/vision.wav")
            ,new AssetBind([
                 "paper"
                ,font.FontFancy8x13.ASSET_ID, font.FontNS.ASSET_ID, font.FontSymbol8x13.ASSET_ID
                ,"paper-alien"
                ,"paper-bunker"
                ,"paper-plane"
                ,"paper-rig"
                ,"paper-sub"
                ,"paper-toxic"
                ,"paper-ufo"
                ,"alert"
                ,"chest"
                ,"enemy-hurt"
                ,"equip"
                ,"gold"
                ,"heal"
                ,"page"
                ,"pause"
                ,"player-death"
                ,"player-hurt"
                ,"player-kill"
                ,"player-step"
                ,"poison"
                ,"unequip"
                ,"victory"
                ,"vision"
              ], (am, _) -> {
                Pal.init(am);
                Text.init(am);
                Renderer.init(am);
                SFX.music();
                false;
              })
          ])
        ,Keyboard
        ,Mouse
      ]);
    preloader = new TNPreloader(this, "game", false);
    addState(g = new Game(this));
    addState(new Fullscreen(this));
    addState(new Switcher(this));
    addState(new Message(this));
    mainLoop();
  }
}
