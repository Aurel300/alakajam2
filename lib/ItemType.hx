package lib;

enum ItemType {
  Weapon(dmg:Int, rate:Int, stun:Int, push:Int);
  Armour(piece:ArmourPiece, def:Int, thorn:Int);
  Food(heal:Int, toxic:Int, poison:Int);
}
