package lix.server.api;

class ProjectsApi implements lix.api.ProjectsApi {
  public function new() {}

  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> return [];
  
  public function byName(name:ProjectName):ProjectApi {
    return new ProjectApi(name);
  }
}