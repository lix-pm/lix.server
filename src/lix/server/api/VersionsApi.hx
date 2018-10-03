package lix.server.api;

class VersionsApi extends BaseApi implements lix.api.VersionsApi {
  var id:ProjectIdentifier;
  
  public function new(id) {
    super();
    this.id = id;
  } 
  
  public function list():Promise<Array<String>> {
    return path(id)
      .next(folder -> fs.list(folder))
      .next(function(items):Array<String> {
        var ret = new Map();
        for(item in items) ret.set(item.split('/')[0], true);
        return [for(key in ret.keys()) key];
      });
  }
    
  public function ofVersion(version:String):VersionApi
    return new VersionApi(id, version);
}