package lix.server.db;

import tink.sql.drivers.MySql;

using tink.CoreApi;

@:tables(Project, User, ProjectVersion, ProjectTag, ProjectRole, Owner, OwnerRole)
class Db extends tink.sql.Database {
  
  static var inst:Db;
  public static function get():DbWrapper {
    if(inst == null) {
      inline function local(name:String) {
        var driver = new MySql({user: 'root', password: ''});
        inst = new Db(name, driver);
      }
    
      #if (environment == "test")
        local('lix_tests');
      #else
        switch Sys.getEnv('DATABASE_URL') {
          case null:
            local('lix');
          case v:
            var url = tink.Url.parse(v);
            var driver = new MySql({user: url.auth.user, password: url.auth.password, host: url.host.name, port: url.host.port});
            inst = new Db(url.path.toString().substr(1), driver);
        }
      #end
    }
    return inst;
  }
}

@:forward
abstract DbWrapper(Db) from Db {
  
  public function init():Promise<Noise> {
    return Promise.inParallel([
      this.Project.create(),
      this.User.create(),
      this.ProjectVersion.create(),
      this.ProjectTag.create(),
      this.ProjectRole.create(),
      this.Owner.create(),
      this.OwnerRole.create(),
    ]);
  }
  
  public function destroy():Promise<Noise> {
    return Promise.inParallel([
      this.Project.drop(),
      this.User.drop(),
      this.ProjectVersion.drop(),
      this.ProjectTag.drop(),
      this.ProjectRole.drop(),
      this.Owner.drop(),
      this.OwnerRole.drop(),
    ]);
  }
  
  public function updateSchema():Promise<Noise> {
    return Promise.inParallel([
      this.Project.diffSchema().next(this.Project.updateSchema),
      this.User.diffSchema().next(this.User.updateSchema),
      this.ProjectVersion.diffSchema().next(this.ProjectVersion.updateSchema),
      this.ProjectTag.diffSchema().next(this.ProjectTag.updateSchema),
      this.ProjectRole.diffSchema().next(this.ProjectRole.updateSchema),
      this.Owner.diffSchema().next(this.Owner.updateSchema),
      this.OwnerRole.diffSchema().next(this.OwnerRole.updateSchema),
    ]);
  }
  
  
}