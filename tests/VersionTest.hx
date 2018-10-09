package;

import haxe.io.Bytes;
import why.fs.*;

using Helper;

@:asserts
class VersionTest extends BaseTest {
  
  public function create() {
    var username = 'my_username';
    var userId;
    var project = 'my_project';
    var version = new Version(1, 0, 0);
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        () -> remote(userId).me().owner().projects().create({name: project})
      ),
      async(
        () -> remote(userId).createVersion(username, project, version),
        v -> v.version == version
      ),
      async(
        // make sure the file exists in fs
        () -> path(Slug('$username/$project'), version).next(path -> fs.list(path)),
        items -> {
          asserts.assert(items.length == 1);
          asserts.assert(items[0] == 'archive.zip');
        }
      ),
      async(
        // check response
        () -> remote(userId).projects().byId('$username/$project').versions().list(),
        versions -> {
          asserts.assert(versions.length == 1);
          asserts.assert(versions[0].version == version);
        }
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function duplicated() {
    var username = 'my_username';
    var userId;
    var project = 'my_project';
    var version = new Version(1, 0, 0);
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        () -> remote(userId).me().owner().projects().create({name: project})
      ),
      async(
        () -> remote(userId).createVersion(username, project, version)
      ),
      asyncError(
        () -> remote(userId).createVersion(username, project, version),
        e -> asserts.assert(e.code == 409)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
}