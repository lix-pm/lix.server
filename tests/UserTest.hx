package;

@:asserts
class UserTest extends BaseTest {
  public function create() {
    new UsersApi().create({
      username: 'my_username',
      password: 'abcd1234',
    })
      .next(function(user) {
        asserts.assert(user.username == 'my_username');
        return Noise;
      })
      .handle(asserts.handle);
    return asserts;
  }
}