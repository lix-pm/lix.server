package lix.api;

interface ProjectApi {
  @:get('/')
  function info():Promise<ProjectDescription>;

  @:sub('/versions')
  function versions():VersionsApi;
}
