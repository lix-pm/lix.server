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
        db.ProjectVersion.insertOne({
          project: id,
          version: data.version,
          dependencies: data.dependencies,
          haxe: data.haxe,
          published: now,
          deprecated: false,
        });
      })
      .next(id -> ({
        version: data.version,
        dependencies: data.dependencies,
        haxe: data.haxe,
        published: now,
        deprecated: false,
      }:ProjectVersion));
  }
  
  public function list():Promise<Array<ProjectVersion>> {
    return getProjectId(id)
      .next(id -> db.ProjectVersion.where(ProjectVersion.project == id).all())
      .next(versions -> {
        var ret:Array<ProjectVersion> = [];
        for(version in versions) {
          switch [Version.parse(version.version), Dependencies.parse(version.dependencies), Constraint.parse(version.haxe)] {
            case [Success(ver), Success(deps), Success(haxeVer)]:
              ret.push({
                version: ver,
                dependencies: deps,
                haxe: haxeVer,
                published: version.published,
                deprecated: version.deprecated,
              });
            case [Failure(e), _, _] | [_, Failure(e), _] | [_, _, Failure(e)]:
              return e;
          }
        }
        ret;
      });
  }
    
  public function ofVersion(version:Version):VersionApi
    return new VersionApi(id, version);
    
  public function canCreate(user:AuthUser):Promise<Bool> {
    return true;
  }
}