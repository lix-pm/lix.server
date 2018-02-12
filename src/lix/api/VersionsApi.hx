package lix.api;

interface VersionsApi {
  @:get('/')
  function list():Promise<Array<String>>;
  
  @:sub('/$version')
  function ofVersion(version:String):VersionApi;
}