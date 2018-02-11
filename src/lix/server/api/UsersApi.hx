package lix.server.api;

import lix.server.util.Password;
import tink.core.ext.*;
import tink.http.Fetch.fetch;

class UsersApi extends BaseApi implements lix.api.UsersApi {
  public function new() {}
  
  public function create(data:{username:String, ?nickname:String, ?password:String, ?github_token:String}) {
    return Promises.multi({
      password:
        switch data.password {
          case null:
            Promise.lift({iterations: null, salt: null, hash: null});
          case password:
            var iter = 256000 + Std.random(20000);
            var salt = haxe.crypto.Sha1.encode('${Date.now().getTime()}${Math.random()}');
            Password.encrypt(password, salt, iter)
              .next(function(hash) return {iterations: iter, salt: salt, hash: hash});
        },
      github:
        switch data.github_token {
          case null:
            Promise.NULL;
          case token:
            fetch('https://api.github.com/user', {
              headers: [
                new HeaderField('user-agent', 'Lix'),
                new HeaderField(AUTHORIZATION, 'token $token'),
                new HeaderField(ACCEPT, 'application/json'),
              ],
            }).all()
              .next(function(req) return tink.Json.parse((req.body:{id:Int})))
              .next(function(profile) return profile.id);
        },
    })
      .next(function(o) {
        return db.User.insertOne({
          id: null,
          username: data.username,
          nickname: data.nickname,
          passwordHash: o.password.hash,
          passwordSalt: o.password.salt,
          passwordIterations: o.password.iterations,
          githubId: o.github,
        })
          .next(function(uid) return {
            id: uid,
            username: data.username,
            nickname: data.nickname,
            githubId: o.github,
          });
      });
  }
  
  public function byName(username:String) 
    return new UserApi(username);
}