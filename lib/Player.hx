package lib;

class Player extends Entity {
  var cdWalk:Int = 0;
  
  public function new(x:Int, y:Int) {
    super(Player, Always);
    this.x = x;
    this.y = y;
  }
  
  override public function pickUpItem(i:Item):Bool {
    trace("picked up " + i.name);
    Main.g.state.rpg.inventory.push(i);
    return true;
  }
  
  override public function pickUpGold(g:Int):Bool {
    trace("picked up " + g);
    Main.g.state.rpg.gold += g;
    return true;
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
