package lix.api;

interface ProjectsApi {
  @:params(filter = query)
  @:get('/')
  function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>>;
  
  @:sub('/$id')
  function byId(id:String):ProjectApi;
}