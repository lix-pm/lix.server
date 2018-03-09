package lix.server.api;

class OwnerApi extends BaseApi implements lix.api.OwnerApi {
  
  var name:String;

  public function new(name:String) {
    super();
    this.name = name;
  }
  
  public function projects()
    return new ProjectsApi(name);
}