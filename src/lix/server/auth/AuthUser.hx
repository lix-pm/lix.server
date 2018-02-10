package lix.server.auth;

import lix.server.db.*;
import tink.sql.Types;

using tink.CoreApi;

class AuthUser {
  public var id(default, null):Id<User>;
  public var data(get, null):Promise<User>;
  
  public function new(id, ?data) {
    this.id = id;
    this.data = data;
  }
  
  function get_data() {
    if(data == null)
      data = Db.get().User.where(User.id == id).first();
    return data;
  }
}