package lix.server.auth;

import lix.server.db.*;
import lix.api.types.*;
import tink.sql.Types;

using tink.CoreApi;

class AuthUser {
  public var id(default, null):Id<User>;
  public var data(get, null):Promise<User>;
  
  var db = Db.get();
  
  public function new(id, ?data) {
    this.id = id;
    this.data = data;
  }
  
  function get_data() {
    if(data == null)
      data = db.User.where(User.id == id).first();
    return data;
  }
  
  public function role(target:Target):Promise<Role> {
    return data.next(function(user) {
      return switch target {
        case Owner(owner) | Project(owner, _) if(owner == user.username):
          Role.Owner;
        case Owner(owner):
          db.OwnerRole.where(OwnerRole.user == id && OwnerRole.owner == owner).first()
            .next(function(o) return o.role);
        case Project(owner, project):
          db.ProjectRole.where(ProjectRole.user == id && ProjectRole.owner == owner && ProjectRole.project == project).first()
            .next(function(o) return o.role);
      }
    });
  }
}

private enum Target {
  Owner(owner:OwnerName);
  Project(owner:OwnerName, project:ProjectName);
}