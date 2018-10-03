package;

import lix.server.db.*;

@:asserts
class UserTest extends BaseTest {
  public function create() {
    var username = 'my_username';
    var userId:Int;
    
    Promise.inSequence([
      async(
        // check API response
        () -> createUser({username: username}),
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
  
  public static function createUser(data, cognitoId = 'dummy_cognito_id') {
    return Db.get().User.insertOne({id: null, cognitoId: cognitoId})
      .next(id -> new UserApi(Id(id)).update({username: Some(data.username), nickname: None}));
  }
}