package lix.api;

interface ProjectsApi {
  @:get('/')
  @:params(filter = query, limit = query)
  function list(?filter:ProjectFilter, ?limit:Limit):Promise<Array<ProjectDescription>>;
  
  @:sub('/$id')
  function byId(id:String):ProjectApi;
}