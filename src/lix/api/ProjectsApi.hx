package lix.api;

interface ProjectsApi {
  @:params(filter = query)
  @:get('/')
  function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>>;
  
  @:sub('/$name')
  function byName(name:ProjectName):ProjectApi;
}