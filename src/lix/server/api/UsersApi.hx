package lix.server.api;

import lix.server.util.Password;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function new() {}
  
  public function create(data:{username:String, ?nickname:String, ?password:String, ?githubId:Int}) {
    var password =
      if(data.password == null) {
        Promise.lift({iterations: null, salt: null, hash: null});
      } else {
        var iter = 256000 + Std.random(20000);
        var salt = haxe.crypto.Sha1.encode('${Date.now().getTime()}${Math.random()}');
        Password.encrypt(data.password, salt, iter)
          .next(function(hash) return {iterations: iter, salt: salt, hash: hash});
      }
      
    return password
      .next(function(password) {
        return db.User.insertOne({
          id: null,
          username: data.username,
          nickname: data.nickname,
          passwordHash: password.hash,
          passwordSalt: password.salt,
          passwordIterations: password.iterations,
          githubId: data.githubId,
        });
      })
      .next(function(uid) return {
        id: uid,
        username: data.username,
        nickname: data.nickname,
        githubId: data.githubId,
      });
  }
  
  public function byName(username:String) 
    return new UserApi(username);
}