package lix.api;

interface OwnerProjectsApi extends ProjectsApi {
  @:post('/')
  @:params(data = body)
  @:restrict(this.canCreate(user))
  function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}):Promise<ProjectDescription>;
  
  @:sub('/$name')
  function byName(name:ProjectName):ProjectApi;
  
  function canCreate(user:AuthUser):Promise<Bool>;
}