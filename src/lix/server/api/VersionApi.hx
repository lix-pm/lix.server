package lix.server.api;

class VersionApi extends BaseApi implements lix.api.VersionApi {
  var owner:OwnerName;
  var project:ProjectName;
  var version:String;
  var path:String;
  
  public function new(owner, project, version) {
    this.owner = owner;
    this.project = project;
    this.version = version;
    this.path = '/libraries/$owner/$project/$version';
  }

  public function url(?upload:Bool):Promise<{url:String}>
    return (upload ? fs.getUploadUrl : fs.getDownloadUrl)('$path/archive.zip')
      .next(function(url) return {url: url});
  
  public function download():Promise<tink.Url>
    return url(false).next(function(o) return tink.Url.parse(o.url));
  
  public function upload():Promise<tink.Url>
    return url(true).next(function(o) return tink.Url.parse(o.url));
}