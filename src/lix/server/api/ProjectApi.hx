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
            var project = o[0].Project;
            {
              name: project.name,
              description: project.description,
              tags: [for(o in o) if(o.ProjectTag != null) o.ProjectTag.tag],
              deprecated: project.deprecated,
              authors: [], // TODO
            }
          });
      case Failure(e):
        e;
    }
  }

  public function versions():VersionsApi 
    return new VersionsApi(id);
}
