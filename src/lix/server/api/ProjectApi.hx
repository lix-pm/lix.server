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

  public function info():Promise<ProjectInfo> 
    return new Error('Not Implemented');

  public function versions():VersionsApi 
    return new VersionsApi(owner, name);
}