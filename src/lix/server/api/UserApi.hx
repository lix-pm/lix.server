package lix.server.api;

import lix.server.util.Password;

class UserApi extends BaseApi implements lix.api.UserApi {
  
  var username:String;
  
  public function new(username) {
    this.username = username;
  }
}