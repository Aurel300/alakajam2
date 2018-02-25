package lib;

class Fullscreen extends JamState {
  public function new(app) super("fullscreen", app);
  
  override public function to() {
    ab.fill(Pal.paper[8]);
  }
  
  override public function tick() {
    if (untyped __js__('fsCheck() === true')) {
      st("game");
      return;
    }
    ab.fill(Pal.paper[8]);
    Text.render(ab, 20, 20, "Click anywhere to enter fullscreen mode");
    Renderer.renderCursor(ab);
  }
  
  override public function mouseClick(_, _) {
    untyped __js__('fsRequest()');
    st("game");
  }
}
