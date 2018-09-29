package lix.api;

interface UsersApi {
  @:post('/')
  @:params(data = body)
  public function create(data:{username:String, ?nickname:String, ?password:String, ?github_token:String}):Promise<User>;
  
  @:sub('/$username')
  function byName(username:String):UserApi;
}