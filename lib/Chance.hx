package lib;

class Chance {
  public static function el<T>(a:Array<T>):T return FM.prng.nextElement(a);
  public static function el2<T>(a:Array<T>):T {
    var total = (0.75) * a.length;
    var step = 0.5 / a.length;
    var cur = 1.0;
    var curTotal = 0.0;
    var chosen = FM.prng.nextFloat(total);
    for (el in a) {
      curTotal += cur;
      if (chosen < curTotal) return el;
      cur -= step;
    }
    return a[0];
  }
  public static function ch(chance:Int):Bool return FM.prng.nextMod(100) < chance;
  public static function n(min:Int, max:Int):Int return min + FM.prng.nextMod(max + 1 - min);
  public static function n2(min:Int, max:Int):Int return min + (FM.prng.nextFloat() * FM.prng.nextFloat() * (max + 1 - min)).floor();
}
