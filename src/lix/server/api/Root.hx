package lix.server.api;

import why.fs.*;

interface ServerRoot extends lix.api.Root {
  #if (environment == "local")
  @:sub
  function files():FilesApi;
  #end
}

class Root extends BaseApi implements ServerRoot {
  public function owners() return new OwnersApi();
  public function users() return new UsersApi();
  public function projects() return new ProjectsApi();
  public function oauth2() return new OAuthApi();
  
  #if (environment == "local")
  public function files() return new FilesApi(fs);
  #end
  
  public function me(user:lix.api.auth.AuthUser) {
    return new UserApi(Id(user.id));
  }
  
  public function version() return {
    buildDate: lix.server.util.Macro.getBuildDate(),
    hash: lix.server.util.Macro.getGitSha(),
  }
}