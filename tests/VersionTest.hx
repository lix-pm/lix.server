package;

import haxe.io.Bytes;

@:tink
@:asserts
class VersionTest extends BaseTest {
  
  public function create() {
    var username = 'my_username';
    var project = 'my_project';
    var version = '1.0.0';
    
    Promise.inSequence([
      async(
        () -> UserTest.createUser({username: username})
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
          @:privateAccess api.fs.list(api.path(username, project, version));
        },
        items -> {
          asserts.assert(items.length == 1);
          asserts.assert(items[0] == 'archive.zip');
        }
      ),
      async(
        // check API response
        () -> new VersionsApi(username, project).list(),
        versions -> {
          asserts.assert(versions.length == 1);
          asserts.assert(versions[0] == version);
        }
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public static function createVersion(owner:String, project:String, version:String, ?archive:Bytes) {
    if(archive == null) archive = Bytes.ofString('dummy');
    return new VersionApi(owner, project, version).upload()
      .next(o -> {
        var path = tink.Url.parse(o.url).query.toMap().get('path');
        return new FilesApi().upload(path, archive);
      });
  }
}