package lix.server.api;

import lix.api.UsersApi;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function byName(username:String) 
    return new UserApi(Username(username));
}