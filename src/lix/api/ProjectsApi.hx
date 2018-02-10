package lix.api;

interface ProjectsApi {
  
  @:post('/')
  @:params(data = body)
  public function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}):Promise<ProjectDescription>;
  
  @:params(filter = query)
  @:get('/')
  function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>>;
  
  @:sub('/$name')
  function byName(name:ProjectName):ProjectApi;
}