package lix.server.api;

class ProjectsApi extends BaseApi implements lix.api.ProjectsApi {
  var owner:OwnerName;
  
  public function new(owner)
    this.owner = owner;

  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> return [];
  
  public function byName(name:ProjectName):ProjectApi {
    return new ProjectApi(owner, name);
  }
}