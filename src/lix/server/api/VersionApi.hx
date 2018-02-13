package lix.server.api;

class VersionApi extends BaseApi implements lix.api.VersionApi {
  public var owner(default, null):OwnerName;
  public var project(default, null):ProjectName;
  var version:String;
  
  public function new(owner, project, version) {
    super();
    this.owner = owner;
    this.project = project;
    this.version = version;
  }

  public function url(?upload:Bool):Promise<{url:String}> {
    var folder = path(owner, project, version);
    var archive = '$folder/archive.zip';
    return fs.exists(archive)
      .next(function(exists) {
        return
          if(upload && exists) new Error('Archive already exists')
          else if(!upload && !exists) new Error('Archive does not exist')
          else Noise;
      })
      .next(function(_) return (upload ? fs.getUploadUrl : fs.getDownloadUrl)(archive))
      .next(function(url) return {url: url});
  }
  
  public function download():Promise<OutgoingResponse>
    return url(false).next(function(o) return redirect(o.url));
  
  public function upload():Promise<OutgoingResponse>
    return url(true).next(function(o) return redirect(o.url));
    
  function redirect(url:String)
    return new OutgoingResponse(new ResponseHeader(307, 'Temporary Redirect', [new HeaderField(LOCATION, url)]), tink.io.Source.EMPTY);
}