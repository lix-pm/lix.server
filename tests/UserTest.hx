package;

import lix.server.db.*;

@:asserts
class UserTest extends BaseTest {
  public function create() {
    var username = 'my_username';
    var userId:Int;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        // check User table
        () -> db.User.where(User.id == userId).count(),
        count -> asserts.assert(count == 1)
      ),
      async(
        // check Owner table
        () -> db.Owner.where(Owner.name == username).count(),
        count -> asserts.assert(count == 1)
      ),
      async(
        // check remote 
        () -> remote(userId).me().get(),
        user -> asserts.assert(user.id == userId)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function duplicatedUsername() {
    var username = 'my_username';
    var userId:Int;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      asyncError(
        () -> Helper.createUser({username: username}),
        e -> asserts.assert(e.code == 409)
      ),
      async(
        // check User table
        () -> db.User.where(User.username == username).count(),
        count -> asserts.assert(count == 1)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
}