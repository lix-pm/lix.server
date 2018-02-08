package lix.api;

interface ProjectApi {
  @:get('/')
  function info():Promise<ProjectInfo>;

  @:sub('/versions')
  function versions():VersionsApi;
}
