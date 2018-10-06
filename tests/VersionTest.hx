package;

import haxe.io.Bytes;
import why.fs.*;

@:asserts
class VersionTest extends BaseTest {
  
  public function create() {
    var username = 'my_username';
    var userId;
    var project = 'my_project';
    var version = new Version(1, 0, 0);
    
    Promise.inSequence([
      async(
        () -> UserTest.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        () -> ProjectTest.createProject(username, {name: project})
      ),
      async(
        () -> createVersion(username, project, version)
      ),
      async(
        // make sure the file exists in fs
        () -> {
          var api = new BaseApi();
          @:privateAccess api.path(Slug('$username/$project'), version).next(path -> api.fs.list(path));
        },
        items -> {
          asserts.assert(items.length == 1);
          asserts.assert(items[0] == 'archive.zip');
        }
      ),
      async(
        // check raw response
        () -> new VersionsApi(Slug('$username/$project')).list(),
        versions -> {
          asserts.assert(versions.length == 1);
          asserts.assert(versions[0].version == version);
        }
      ),
      async(
        // check remote response
        () -> remote(userId).projects().byId('$username/$project').versions().list(),
        versions -> {
          asserts.assert(versions.length == 1);
          asserts.assert(versions[0].version == version);
        }
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public static function createVersion(owner:String, project:String, version:Version, ?archive:Bytes) {
    if(archive == null) archive = Bytes.ofString('dummy');
    return new ProjectApi(Slug('$owner/$project')).versions()
      .create({
        version: version,
        dependencies: [],
        haxe: null,
      })
      .next(v -> new VersionApi(Slug('$owner/$project'), version).upload())
      .next(o -> {
        var path = tink.Url.parse(o.url).query.toMap().get('path');
        return new FilesApi(@:privateAccess new BaseApi().fs).upload(path, archive);
      });
  }
}