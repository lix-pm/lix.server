package lix.api;

interface UsersApi {
  @:post('/')
  function create(body:NewUserData, user:AuthUser):Promise<User>;
  
  @:sub('/$username')
  function byName(username:String):UserApi;
}

typedef NewUserData = {
  username:String,
  ?nickname:String,
}