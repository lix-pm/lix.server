package lix.server.api;

class VersionsApi extends BaseApi implements lix.api.VersionsApi {
  var id:ProjectIdentifier;
  
  public function new(id) {
    super();
    this.id = id;
  } 
  
  public function create(data:{version:Version, dependencies:Dependencies, haxe:Constraint}):Promise<ProjectVersion> {
    var now = Date.now();
    return getProjectId(id)
      .next(id -> {
        Promise.inParallel([
          db.ProjectVersion.insertOne({
            project: id,
            version: data.version,
            haxe: data.haxe,
            published: now,
            deprecated: null,
          }).noise(),
          db.ProjectVersionDependency.insertMany([for(dep in data.dependencies) {
            project: id,
            version: data.version,
            name: dep.name,
            constraint: dep.constraint,
          }]).noise(),
        ]);
      })
      .next(_ -> ({
        version: data.version,
        dependencies: data.dependencies,
        haxe: data.haxe,
        published: now,
        deprecated: null,
      }:ProjectVersion));
  }
  
  public function list():Promise<Array<ProjectVersion>> {
    return getProjectId(id)
      .next(id -> {
        db.ProjectVersion
          .leftJoin(db.ProjectVersionDependency).on(ProjectVersionDependency.project == ProjectVersion.project && ProjectVersionDependency.version == ProjectVersion.version)
          .where(ProjectVersion.project == id)
          .all();
      })
      .next(rows -> {
        var ret = new Map();
        for(row in rows) {
          if(!ret.exists(row.ProjectVersion.version)) {
            switch [Version.parse(row.ProjectVersion.version), Constraint.parse(row.ProjectVersion.haxe)] {
              case [Success(ver), Success(haxeVer)]:
                ret[row.ProjectVersion.version] = {
                  version: ver,
                  dependencies: [],
                  haxe: haxeVer,
                  published: row.ProjectVersion.published,
                  deprecated: row.ProjectVersion.deprecated,
                }
              case [Failure(e), _] | [_, Failure(e)]:
                return e;
            }
          }
          if(row.ProjectVersionDependency != null) { 
            switch Constraint.parse(row.ProjectVersionDependency.constraint) {
              case Success(constraint):
                ret[row.ProjectVersion.version].dependencies.push({
                  name: row.ProjectVersionDependency.name,
                  constraint: constraint,
                });
              case Failure(e):
                return e;
            }
          }
        }
        ([for(v in ret) v]:Array<ProjectVersion>);
      });
  }
    
  public function byVersion(version:Version):VersionApi
    return new VersionApi(id, version);
    
  public function canCreate(user:AuthUser):Promise<Bool> {
    return user.hasRole(Project(id), Publisher);
  }
}