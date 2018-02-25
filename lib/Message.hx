package lib;

class Message extends JamState {
  public static var msg:String;
  
  var timeOut = 0;
  
  public function new(app) super("message", app);
  
  override public function to() {
    ab.fill(Pal.paper[8]);
    timeOut = 30;
  }
  
  override public function tick() {
    ab.fill(Pal.paper[8]);
    Text.render(ab, 20, 20, msg);
    if (timeOut > 0) timeOut--;
    Renderer.renderCursor(ab);
  }
  
  override public function mouseClick(_, _) {
    if (timeOut != 0) return;
    Main.g.state.menu();
    st("game");
  }
}
