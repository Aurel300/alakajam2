package lib;

enum RoomVisual {
  Justify(txt:String, x:Int, y:Int, w:Int);
  Photo(id:String, x:Int, y:Int, w:Int, h:Int);
  Bitmap(bd:Bitmap, x:Int, y:Int);
}
