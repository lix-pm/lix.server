package lix.server.api;

class VersionsApi extends BaseApi implements lix.api.VersionsApi {
  var owner:OwnerName;
  var project:ProjectName;
  
  public function new(owner, project) {
    super();
    this.owner = owner;
    this.project = project;
  } 
  
  public function list():Promise<Array<String>> {
    var folder = path(owner, project);
    return fs.list(folder)
      .next(function(items):Array<String> {
        var ret = new Map();
        for(item in items) ret.set(item.split('/')[0], true);
        return [for(key in ret.keys()) key];
      });
  }
    
  public function ofVersion(version:String):VersionApi
    return new VersionApi(owner, project, version);
}