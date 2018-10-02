package lix.server.api;

import why.Fs;

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
  
  public function download():Promise<UrlRequest> {
    var path = getArchivePath();
    return fs.exists(path)
      .next(exists -> {
        if(exists) fs.getDownloadUrl(path, {isPublic: true});
        else new Error(NotFound, 'Archive $owner/$project#$version does not exists');
      });
  }
  
  public function upload():Promise<UrlRequest> {
    var path = getArchivePath();
    return fs.exists(path)
      .next(exists -> {
        if(!exists) fs.getUploadUrl(path, {isPublic: true, mime: 'application/zip'});
        else new Error(Conflict, 'Archive $owner/$project#$version alraedy exists');
      });
  }
  
  function getArchivePath()
    return path(owner, project, version) + 'archive.zip';
}