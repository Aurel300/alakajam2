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
      case ArrowRight | KeyD: state.player.x++;
      case ArrowLeft  | KeyA: state.player.x--;
      case ArrowDown  | KeyS: state.player.y++;
      case ArrowUp    | KeyW: state.player.y--;
      case _:
    }
  }
}
