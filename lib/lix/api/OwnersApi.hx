package lix.api;

interface OwnersApi {
  @:post('/')
  @:params(name in body)
  function create(name:OwnerName, user:AuthUser):Promise<OwnerInfo>;
    
  @:sub('/$name')
  function byName(name:OwnerName):OwnerApi;
}