package lix.server.api;

import lix.api.UsersApi;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function create(body:NewUserData, user:lix.api.auth.AuthUser):Promise<User> {
    // TODO: validate username
    return db.User.insertOne({
      id: null,
      cognitoId: user.id,
      username: body.username,
      nickname: body.nickname,
    })
      // TODO: need transaction in case owner name is taken
      .next(function(uid) {
        return db.Owner.insertOne({
          id: null,
          name: body.username,
        }).swap(uid);
      })
      .next(_ -> db.User.where(User.username == body.username).first());
  }
  
  public function byName(username:String) 
    return new UserApi(Username(username));
}