package lib;

enum RoomVisual {
  Justify(txt:String, x:Int, y:Int, w:Int);
  JustifyFont(txt:String, x:Int, y:Int, w:Int, ft:FontType);
  Photo(id:String, x:Int, y:Int, w:Int, h:Int);
  Bitmap(bd:Bitmap, x:Int, y:Int);
  Text(txt:String, x:Int, y:Int);
  Fold(x:Int, y:Int, w:Int);
}
