package lix.server.api;

class Root extends BaseApi implements lix.api.Root {
	public function new() {}
	public function owners() return new OwnersApi();
  
  #if (environment == "local")
  public function files() return new FilesApi();
  #end
}