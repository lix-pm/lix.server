package lix.api;

interface OwnersApi {
  @:sub('/$name')
  function byName(name:OwnerName):OwnerApi;
}