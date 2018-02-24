package lib;

class Player extends Entity {
  var cdWalk:Int = 0;
  
  public function new() {
    super(Player, Always);
    x = y = 2;
  }
  
  override public function tick(state:GameState):Void {
    room.visited = true;
    if (cdWalk == 0) {
      if (walkOrtho(
           (1).negposI(state.keys.left, state.keys.right)
          ,(1).negposI(state.keys.up, state.keys.down)
        )) cdWalk = state.rpg.speed;
    } else cdWalk--;
  }
  
  override public function print(str:Array<Array<String>>, pov:Int):Void {
    put(str, x, y, Text.t(Mono1) + "@");
  }
}
