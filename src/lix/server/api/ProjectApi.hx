package lix.server.api;

class ProjectApi extends BaseApi implements lix.api.ProjectApi {

  var id:ProjectIdentifier;
  
  public function new(id) {
    super();
    this.id = id;
  }

  public function info():Promise<ProjectDescription> {
    return switch id.sanitize() {
      case Success(sanitized):
        db.Owner
          .leftJoin(db.Project).on(Project.owner == Owner.id)
          .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
          .where(switch sanitized {
            case Id(id):
              Project.id == id;
            case Name(owner, name):
              Owner.name == owner && Project.name == name;
          })
          .all()
          .next(o -> {
            if(o.length == 0) return new Error(NotFound, 'Not found');
            var project = o[0].Project;
            var owner = o[0].Owner;
            ({
              id: project.id,
              owner: owner.name,
              name: project.name,
              url: project.url,
              description: project.description,
              tags: [for(o in o) if(o.ProjectTag != null) o.ProjectTag.tag],
              deprecated: project.deprecated,
              authors: [], // TODO
            }:ProjectDescription);
          });
      case Failure(e):
        e;
    }
  }
  
  public function deprecate(message:String):Promise<Noise> {
    return getProjectId(id)
      .next(pid -> db.Project.update(
        p -> [p.deprecated.set(message)],
        {where: p -> p.id == pid}
      ));
  }
  
  public function versions():VersionsApi 
    return new VersionsApi(id);
  
  public function canDeprecate(user:AuthUser):Promise<Bool>
    return user.hasRole(Project(id), Publisher);
}
