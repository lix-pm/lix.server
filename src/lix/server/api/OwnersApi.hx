package lix.server.api;

class OwnersApi extends BaseApi implements lix.api.OwnersApi {
  public function new() {}
  
  public function byName(name:OwnerName) return new OwnerApi(name);
}