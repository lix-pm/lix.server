package;

import lix.server.db.*;

class BaseTest {
  var db = Db.get();
  
  public function new() {}
  
  @:before
  public function init() {
    return db.destroy().flatMap(function(_) return db.init());
  }
  
  function async<T>(promise:Void->Promise<T>, ?assert:T->Void) {
    return Promise.lazy(promise).next(function(v) {
        if(assert != null) assert(v);
        return Noise;
      });
  }
}