package lix.server.auth;

import lix.server.db.Db;
import lix.server.db.User;
import lix.api.auth.AuthUser;
import lix.api.types.OwnerName;
import lix.api.types.ProjectName;
import lix.api.types.Role;
import tink.sql.Types;

using tink.CoreApi;

class AuthUser implements lix.api.auth.AuthUser {
  public var id(default, null):String;
  public var data(get, null):Promise<User>;
  
  var db = Db.get();
  
  public function new(id, ?data) {
    this.id = id;
    this.data = data;
  }
  
  function get_data() {
    if(data == null)
      data = db.User.where(User.cognitoId == id).first();
    return data;
  }
  
  public function hasRole(target:Target, role:Role):Promise<Bool> {
    function check(actual:Role):Promise<Bool> {
      var roles:Array<Role> = switch role {
        case Publisher: [Owner, Admin, Publisher];
        case Admin: [Owner, Admin];
        case Owner: [Owner];
      }
      return roles.indexOf(actual) != -1;
    }
    
    return data.next(function(user) {
      return switch target {
        case Owner(owner) | Project(owner, _) if(owner == user.username):
          true; // has all roles
        case Owner(owner):
          db.Owner
            .leftJoin(db.OwnerRole).on(OwnerRole.owner == Owner.id)
            .where(Owner.name == owner )
            .first()
            .next(function(o) return check(o.OwnerRole.role));
        case Project(owner, project):
          db.Owner
            .leftJoin(db.Project).on(Project.owner == Owner.id)
            .leftJoin(db.ProjectRole).on(ProjectRole.project == Project.id)
            .where(Owner.name == owner && Project.name == project)
            .first()
            .next(function(o) return check(o.ProjectRole.role))
            .next(function(has) return has ? true : hasRole(Owner(owner), role));
      }
    });
  }
}
