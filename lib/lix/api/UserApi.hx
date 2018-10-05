package lix.api;

interface UserApi {
  @:get('/')
  function get():Promise<User>;
  
  @:patch('/')
  @:consumes('application/json')
  function update(body:UserPatch):Promise<User>;
  
  @:sub
  function owner():Promise<OwnerApi>;
}

typedef UserPatch = {
  username:Option<String>,
  nickname:Option<String>,
}