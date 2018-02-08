package lix.api;

interface VersionsApi {
  @:get('/')
  function list():Promise<Array<{}>>;
	
  @:sub('/$version')
  function ofVersion(version:String):VersionApi;
}