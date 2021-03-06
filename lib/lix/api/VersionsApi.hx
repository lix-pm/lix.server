package lix.api;

interface VersionsApi {
  @:post('/')
  @:restrict(this.canCreate(user))
  @:consumes('application/json')
  function create(body:{version:Version, dependencies:Dependencies, haxe:Constraint}):Promise<ProjectVersion>;
  
  @:get('/')
  function list():Promise<Array<ProjectVersion>>;
  
  @:sub
  function latest():Promise<VersionApi>;
  
  @:sub('/$version')
  function byVersion(version:Version):VersionApi;
  
  function canCreate(user:AuthUser):Promise<Bool>;
}