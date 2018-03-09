package lix.server.api;

class Root extends BaseApi implements lix.api.Root {
  public function owners() return new OwnersApi();
  public function users() return new UsersApi();
  public function projects() return new ProjectSearchApi();
  public function oauth() return new OAuthApi();
  
  #if (environment == "local")
  public function files() return new FilesApi();
  #end
}