package lix.api;

interface ProjectsApi {
  var scope(default, null):Scope;
  
  @:post('/')
  @:params(data = body)
  @:restrict(switch this.scope {
    case Global: new tink.core.Error(BadRequest, 'Cannot create project in global scope');
    case Owner(name): user.role(Owner(name)).next(function(role) return role == Admin);
  })
  function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}):Promise<ProjectDescription>;
  
  @:params(filter = query)
  @:get('/')
  function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>>;
  
  @:sub('/$name')
  function byName(name:ProjectName):Promise<ProjectApi>;
}

enum Scope {
  Global;
  Owner(owner:OwnerName);
}