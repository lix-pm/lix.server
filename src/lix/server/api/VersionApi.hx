package lix.server.api;

import why.Fs;

using haxe.io.Path;

class VersionApi extends BaseApi implements lix.api.VersionApi {
  public var id(default, null):ProjectIdentifier;
  var version:Version;
  
  public function new(id, version) {
    super();
    this.id = id;
    this.version = version;
  }
  
  public function download():Promise<UrlRequest> {
    return getArchivePath()
      .next(path -> {
        fs.exists(path)
          .next(exists -> {
            if(exists) fs.getDownloadUrl(path, {isPublic: true});
            else new Error(NotFound, 'Archive does not exists');
          });
      });
  }
  
  public function upload():Promise<UrlRequest> {
    return getArchivePath()
      .next(path -> {
        fs.exists(path)
          .next(exists -> {
            if(!exists) fs.getUploadUrl(path, {isPublic: true, mime: 'application/zip'});
            else new Error(Conflict, 'Archive already exists');
          });
      });
  }
  
  public function canUpload(user:AuthUser):Promise<Bool>
    return user.hasRole(Project(id), Publisher);
  
  function getArchivePath()
    return path(id, version).next(path -> return Path.join([path, 'archive.zip']));
    
}