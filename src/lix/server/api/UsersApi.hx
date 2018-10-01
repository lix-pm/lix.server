package lix.server.api;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function byName(username:String) 
    return new UserApi(username);
}