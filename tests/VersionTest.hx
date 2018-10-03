package;

import haxe.io.Bytes;

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
          @:privateAccess api.path(Slug('$username/$project'), version).next(path -> api.fs.list(path));
        },
        items -> {
          asserts.assert(items.length == 1);
          asserts.assert(items[0] == 'archive.zip');
        }
      ),
      async(
        // check API response
        () -> new VersionsApi(Slug('$username/$project')).list(),
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
    return new VersionApi(Slug('$owner/$project'), version).upload()
      .next(o -> {
        var path = tink.Url.parse(o.url).query.toMap().get('path');
        return new FilesApi().upload(path, archive);
      });
  }
}