package lix.api;

interface UserApi {
  @:get('/')
  function get():Promise<User>;
  
  @:patch('/')
  @:consumes('application/json')
  function update(body:UserPatch):Promise<User>;
}

typedef UserPatch = {
  username:Option<String>,
  nickname:Option<String>,
}