package lib;

class Game extends JamState {
  public function new(app) super("game", app);
  
  public var ren:Renderer;
  public var state:GameState;
  
  override public function to() {
    ren = new Renderer();
    state = new GameState();
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
}
