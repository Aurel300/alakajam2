package lib;

class Player extends Entity {
  public function new() {
    super(Player);
    x = y = 1;
  }
  
  override public function print(str:Array<Array<String>>):Void {
    str[y][x] = Text.t(Mono1) + "@" + Text.tr;
  }
  
  /*
  override public function render(ab:Bitmap, ox:Int, oy:Int):Void {
    Text.render(
        ab, ox + x * Renderer.TILE_SIZE - 1, oy + y * Renderer.TILE_SIZE - 4, "@"
      );
  }
  */
}
