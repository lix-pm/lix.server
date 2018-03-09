package lix.api;

interface ProjectsApi extends ProjectSearchApi {
  
  @:post('/')
  @:params(data = body)
  function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}):Promise<ProjectDescription>;
  
  @:sub('/$name')
  function byName(name:ProjectName):Promise<ProjectApi>;
}