package lix.server.api;

class ProjectApi extends BaseApi implements lix.api.ProjectApi {

  var owner:OwnerName;
  var name:ProjectName;
  var path:String;
  
  public function new(owner, name) {
    this.owner = owner;
    this.name = name;
    this.path = '/libraries/$owner/$name';
  }

  public function info():Promise<ProjectDescription> {
    return db.Owner
      .leftJoin(db.Project).on(Project.owner == Owner.id)
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where(Owner.name == owner && Project.name == name)
      .all()
      .next(function(o) {
        var project = o[0].Project;
        return {
          name: project.name,
          description: project.description,
          tags: [for(o in o) if(o.ProjectTag != null) o.ProjectTag.tag],
          deprecated: project.deprecated,
          authors: [], // TODO
        }
      });
  }

  public function versions():VersionsApi 
    return new VersionsApi(owner, name);
}