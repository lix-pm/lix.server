package;

@:tink
@:asserts
class UserTest extends BaseTest {
  public function create() {
    var username = 'my_username';
    
    Promise.inSequence([
      async(
        [] => createUser({username: username}),
        user => asserts.assert(user.username == username)
      ),
      async(
        [] => db.User.where(User.username == username).count(),
        count => asserts.assert(count == 1)
      ),
      async(
        [] => db.Owner.where(Owner.name == username).count(),
        count => asserts.assert(count == 1)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public static function createUser(data = {username: 'dummy', password: 'dummy', nickname: 'Dummy', github_token: null}) {
    return new UsersApi().create(data);
  }
}