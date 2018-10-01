package lix.server.api;

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
    }).first();
  }
}

enum UserIdentifier {
  Username(username:String);
  CognitoId(id:String);
}