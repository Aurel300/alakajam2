package lib;

class Game extends JamState {
  public var ren:Renderer;
  public var state:GameState;
  
  public function new(app) {
    super("game", app);
  }
  
  override public function to() {
    if (ren == null) {
      ren = new Renderer();
      state = new GameState();
    }
  }
  
  override public function tick() {
    state.keys = {
         left:  ak(ArrowLeft)  || ak(KeyA)
        ,up:    ak(ArrowUp)    || ak(KeyW)
        ,right: ak(ArrowRight) || ak(KeyD)
        ,down:  ak(ArrowDown)  || ak(KeyS)
      };
    state.tick();
    ren.render(state, ab);
  }
  
  override public function mouseMove(mx, my) {
    ren.mouseMove(state, mx, my);
  }
  
  override public function mouseClick(mx, my) {
    ren.mouseMove(state, mx, my);
    state.vision();
  }
  
  override public function keyUp(key:Key) {
    switch (key) {
      case KeyC:
      state.charTween.toggle();
      SFX.p("pause");
      case _:
    }
  }
}
