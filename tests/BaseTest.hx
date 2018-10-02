package;

import lix.server.db.*;

class BaseTest {
  var db = Db.get();
  
  public function new() {}
  
  @:before
  public function init() {
    return Promise.inParallel([
      @:privateAccess new BaseApi().fs.delete('/').recover(function(_) return Noise),
      db.destroy().flatMap(_ -> db.init()),
    ]);
  }
  
  function async<T>(promise:Void->Promise<T>, ?assert:T->Void) {
    return Promise.lazy(promise).next(v -> {
        if(assert != null) assert(v);
        Noise;
      });
  }
  
  function asyncError<T>(promise:Void->Promise<T>, ?assert:Error->Void) {
    return Promise.lazy(promise).map(o -> switch o {
        case Success(_): Failure(new Error('Expected Failure but got Success'));
        case Failure(e): assert(e); Success(Noise);
      });
  }
}