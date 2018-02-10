package lix.server.util;

using tink.CoreApi;

@:build(futurize.Futurize.build())
class Password {
  public static function encrypt(raw:String, salt:String, iterations:Int) {
    return @:futurize js.node.Crypto.pbkdf2(raw, salt, iterations, 512, 'sha512', $cb1)
      .next(function(buffer) return buffer.toString('hex'));
  }
}