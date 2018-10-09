package;

import haxe.io.Bytes;
import lix.server.api.*;
import lix.server.db.*;
import why.fs.*;
import tink.Chunk;

class Helper {
  public static function createUser(data) {
    return Db.get().User.insertOne({id: null, cognitoId: Date.now().getTime() + '-' + Std.random(1<<24)}) // this is normally done by cognito's pre-token trigger
      .next(id -> new UserApi(Id(id)).update({username: Some(data.username), nickname: None}));
  }
  
  public static function createVersion(remote:Remote, owner:String, project:String, version:Version, ?archive:Chunk) {
    if(archive == null) archive = 'dummy';
    return remote.owners().byName(owner).projects().byName(project).versions()
      .create({
        version: version,
        dependencies: [],
        haxe: null,
      })
      .next(v -> {
        remote.owners().byName(owner).projects().byName(project).versions().byVersion(version).upload()
          .next(o -> {
            var path = tink.Url.parse(o.url).query.toMap().get('path');
            return new FilesApi(Boot.fs).upload(path, archive);
          })
          .swap(v);
      });
  }
}