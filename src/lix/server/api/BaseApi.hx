package lix.server.api;

import lix.util.Config.*;
import lix.server.db.*;
import tink.http.Method;
import why.Fs;
import why.fs.*;


class BaseApi {
  
  public function new() {}
  
  var fs:Fs =
    #if (environment == "prod")
      new S3('lix-production')
    #else
      new Local({
        root: './storage',
        getDownloadUrl: path -> {
          url: '$API_SERVER_URL/files?path=$path',
          method: GET,
        },
        getUploadUrl: (path, _) -> {
          url: '$API_SERVER_URL/files?path=$path',
          method: PUT,
        },
      })
    #end ;
  var db = Db.get();
  
  function path(id:ProjectIdentifier, ?version:Version):Promise<String> {
    var base = '/libraries';
    return getProjectId(id)
      .next(id -> {
        var path = '$base/$id';
        version == null ? path : '$path/$version';
      });
  }
  
  function getProjectId(id:ProjectIdentifier):Promise<Id<Project>> {
    return switch id.sanitize() {
      case Success(Id(int)):
        (int:Id<Project>);
      case Success(Name(owner, name)):
        db.Owner
          .leftJoin(db.Project).on(Project.owner == Owner.id)
          .where(Owner.name == owner && Project.name == name)
          .first()
          .next(o -> o.Project.id);
      case Failure(e):
        Promise.lift(e);
    }
  }
}