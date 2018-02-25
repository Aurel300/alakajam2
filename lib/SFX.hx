package lib;

import sk.thenet.audio.*;

class SFX {
  public static var enabled:Bool = true;
  
  public static function p(id:String):Void {
    if (!enabled) return;
    Main.g.amS(id).play();
  }
  
  public static function music():Void {
    /*
    var out = Platform.createAudioOutput();
    var prng = new sk.thenet.stream.prng.Generator(new sk.thenet.stream.prng.ParkMiller(0xDEAFDEAF));
    var tempo = 550;
    var channels = new Vector<Float>(10);
    var volumes = new Vector<Float>(10);
    var freqs = new Vector<Float>(10);
    var ideal = 4;
    for (i in 0...7) {
      channels[i] = prng.nextFloat();
      volumes[i] = 0.5 / Math.pow(2, i);
      freqs[i] = 50 * Math.pow(2, i);
    }
    out.sample = (offset, buffer) -> {
        for (i in 0...8192) {
          var o = 0.0;
          for (j in 0...7) {
            o += Math.sin(((i + offset) / 8192) * freqs[j]) * volumes[j];
          }
          buffer[i << 1] = buffer[(i << 1) + 1] = o;
          if (i % 64 == 0) {
            //tempo += prng.nextMod(5) - 2;
            //ideal = prng.nextMod(10);
            //for (j in 0...7) freqs[j] += Math.sin(((offset + i) / 8192) / 400) * 0.01;
          }
        }
      };
    out.play();
    */
  }
}
