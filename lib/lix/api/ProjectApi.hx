package lix.api;

interface ProjectApi {
  @:get('/')
  function info():Promise<ProjectDescription>;
  
  @:put
  @:restrict(this.canDeprecate(user))
  @:params(message in body)
  function deprecate(message:String):Promise<Noise>;

  @:sub('/versions')
  function versions():VersionsApi;
  
  function canDeprecate(user:AuthUser):Promise<Bool>;
}
