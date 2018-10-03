package lix.server.api;

class OwnerApi extends BaseApi implements lix.api.OwnerApi {
  
  var owner:OwnerName;

  public function new(owner) {
    super();
    this.owner = owner;
  }
  
  public function projects()
    return new OwnerProjectsApi(owner);
}