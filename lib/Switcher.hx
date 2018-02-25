package lib;

class Switcher extends JamState {
  public static var tasks:Array<{text:String, work:Void->Bool, ?next:String}> = [];
  
  public function new(app) super("switcher", app);
  
  override public function to() {
    ab.fill(Pal.paper[8]);
  }
  
  override public function tick() {
    ab.fill(Pal.paper[8]);
    if (tasks.length > 0) {
      Text.render(ab, 20, 270, tasks[0].text);
      if (tasks[0].work()) {
        var fin = tasks.shift();
        if (fin.next != null) {
          st(fin.next);
          return;
        }
      }
    }
    Renderer.renderCursor(ab);
  }
}
