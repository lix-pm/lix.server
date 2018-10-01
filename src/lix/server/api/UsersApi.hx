package lix.server.api;

import lix.api.UsersApi;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function create(body:NewUserData, user:lix.api.auth.AuthUser):Promise<User> {
    return db.User.insertOne({
      id: null,
      cognitoId: user.id,
      username: body.username,
      nickname: body.nickname,
    }).next(id -> db.User.where(User.id == id).first());
  }
  
  public function byName(username:String) 
    return new UserApi(Username(username));
}