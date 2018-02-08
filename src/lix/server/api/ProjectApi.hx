package lix.server.api;

class ProjectApi implements lix.api.ProjectApi {

  var path:String;
  
  public function new(name:String) {
    this.path = '/libraries/$name';
  }

  public function submit(version:String, archive:tink.io.Source.RealSource):Promise<{}> {
    return new Error('Not Implemented');
  }

  public function info():Promise<ProjectInfo> 
    return new Error('Not Implemented');

  public function version(version:Version):VersionApi 
    return new VersionApi(version);

}