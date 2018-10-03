package lix.server.api;

import lix.api.UserApi;

class UserApi extends BaseApi implements lix.api.UserApi {
  
  var id:UserIdentifier;
  
  public function new(id) {
    super();
    this.id = id;
  }
  
  public function get() {
    return db.User.where(switch id {
      case Username(username): User.username == username;
      case CognitoId(id): User.cognitoId == id;
      case Id(id): User.id == id;
    }).first();
  }
  
  public function update(patch:UserPatch):Promise<User> {
    return (switch patch.username {
      case Some(username):
        get()
          .next(user -> {
            if(user.username == null) {
              db.Owner.insertOne({
                id: null,
                name: username,
              }).noise();
            } else {
              db.Owner.update(
                o -> [o.name.set(username)],
                {where: o -> o.name == user.username}
              ).noise();
            }
          });
      case None:
        Promise.NOISE;
    })
      .next(_ -> db.User.update(
        u -> {
          var ret = [];
          switch patch.username {
            case Some(v): ret.push(u.username.set(v));
            case None:
          }
          switch patch.nickname {
            case Some(v): ret.push(u.nickname.set(v));
            case None:
          }
          ret;
        },
        {where: u -> switch id {
          case Username(username): u.username == username;
          case CognitoId(id): u.cognitoId == id;
          case Id(id): u.id == id;
        }}
      ))
      .next(_ -> get());
  }
}

enum UserIdentifier {
  Username(username:String);
  CognitoId(id:String);
  Id(id:Int);
}