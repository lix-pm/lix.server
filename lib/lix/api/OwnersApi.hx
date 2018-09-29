package lix.api;

interface OwnersApi {
  @:post('/')
  @:params(data = body)
  function create(data:{name:OwnerName, admin:Int}):Promise<OwnerInfo>;
    
  @:sub('/$name')
  function byName(name:OwnerName):OwnerApi;
}