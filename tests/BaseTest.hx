package;

import lix.server.db.*;

class BaseTest {
  public function new() {}
  
  @:before
  public function init() {
    var db = Db.get();
    return db.destroy().flatMap(function(_) return db.init());
  }
}