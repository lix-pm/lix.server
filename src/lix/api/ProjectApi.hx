package lix.api;

interface ProjectApi {
  @:get('/')
  function info():Promise<ProjectInfo>;

  @:put('/$version')
  @:params(archive = body)
  function submit(version:String, archive:tink.io.Source.RealSource):Promise<{}>;

  @:sub('/$version')
  function version(version:Version):VersionApi;
}
