package lix.api;

interface OwnerProjectsApi extends ProjectsApi {
  @:post('/')
  @:params(data = body)
  @:restrict(this.canCreate(user))
  function create(data:NewProjectData):Promise<ProjectDescription>;
  
  @:sub('/$name')
  function byName(name:ProjectName):ProjectApi;
  
  function canCreate(user:AuthUser):Promise<Bool>;
}

typedef NewProjectData = {
  name:String, 
  ?url:String, 
  ?description:String, 
  ?authors:Array<Author>,
  ?tags:Array<Tag>,
}