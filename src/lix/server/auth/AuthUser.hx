package lix.server.auth;

import lix.server.db.Db;
import lix.server.db.User;
import lix.api.types.OwnerName;
import lix.api.types.ProjectName;
import lix.api.types.Role;
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
  
  public function role(target:Target):RolePromise {
    return data.next(function(user) {
      return switch target {
        case Owner(owner) | Project(owner, _) if(owner == user.username):
          Role.Owner;
        case Owner(owner):
          db.Owner
            .leftJoin(db.OwnerRole).on(OwnerRole.owner == Owner.id)
            .where(Owner.name == owner )
            .first()
            .next(function(o) return o.OwnerRole.role);
        case Project(owner, project):
          db.Owner
            .leftJoin(db.Project).on(Project.owner == Owner.id)
            .leftJoin(db.ProjectRole).on(ProjectRole.project == Project.id)
            .where(Owner.name == owner && Project.name == project)
            .first()
            .next(function(o) return o.ProjectRole.role);
      }
    });
  }
}

private enum Target {
  Owner(owner:OwnerName);
  Project(owner:OwnerName, project:ProjectName);
}

@:forward
private abstract RolePromise(Promise<Role>) from Promise<Role> to Promise<Role> {
  public function is(role:Role)
    return this.next(function(r) return r == role);
}