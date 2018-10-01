package lix.server.api;

class UserApi extends BaseApi implements lix.api.UserApi {
  
  var username:String;
  
  public function new(username) {
    super();
    this.username = username;
  }
  
  public function get() {
    return db.User.where(User.username == username).first();
  }
}