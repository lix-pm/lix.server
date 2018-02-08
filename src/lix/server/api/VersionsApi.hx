package lix.server.api;

class VersionsApi extends BaseApi implements lix.api.VersionsApi {
  var owner:OwnerName;
  var project:ProjectName;
  
  public function new(owner, project) {
    this.owner = owner;
    this.project = project;
  } 
  
  public function list():Promise<Array<{}>>
    return new Error('not implemented');
    
  public function ofVersion(version:String):VersionApi
    return new VersionApi(owner, project, version);
}