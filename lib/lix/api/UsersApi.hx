package lix.api;

interface UsersApi {
  @:sub('/$username')
  function byName(username:String):UserApi;
}

typedef NewUserData = {
  username:String,
  ?nickname:String,
}