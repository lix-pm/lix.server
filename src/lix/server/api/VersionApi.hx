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
  
  public function get():Promise<ProjectVersion> {
    return getProjectId(id)
      .next(pid -> db.ProjectVersion
        .leftJoin(db.ProjectVersionDependency).on(ProjectVersion.project == ProjectVersionDependency.project && ProjectVersion.version == ProjectVersionDependency.version)
        .where(ProjectVersion.project == pid && ProjectVersion.version == version)
        .all()
      )
      .next(rows -> {
        var version = rows[0].ProjectVersion;
        var ret:ProjectVersion = {  
          version: version.version,
          dependencies: [],
          haxe: version.haxe,
          published: version.published,
          deprecated: version.deprecated,
        }
        for(row in rows)
          switch row.ProjectVersionDependency {
            case null:
            case dep:
              ret.dependencies.push({
                name: dep.name,
                constraint: dep.constraint,
              });
          }
        ret;
      });
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
  
  public function deprecate(message:String):Promise<Noise> {
    return getProjectId(id)
      .next(pid -> db.ProjectVersion.update(
        v -> [v.deprecated.set(message)],
        {where: v -> v.project == pid && v.version == version}
      ));
  }
  
  public function canUpload(user:AuthUser):Promise<Bool>
    return user.hasRole(Project(id), Publisher);
  
  public function canDeprecate(user:AuthUser):Promise<Bool>
    return user.hasRole(Project(id), Publisher);
  
  function getArchivePath()
    return path(id, version).next(path -> return Path.join([path, 'archive.zip']));
    
}