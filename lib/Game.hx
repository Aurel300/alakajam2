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
  
  override public function keyUp(key:Key) {
    switch (key) {
      case ArrowRight: state.player.x++;
      case ArrowLeft: state.player.x--;
      case ArrowDown: state.player.y++;
      case ArrowUp: state.player.y--;
      case _:
    }
  }
}
