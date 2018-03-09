package lix.api;

interface ProjectSearchApi {
  @:params(filter = query)
  @:get('/')
  function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>>;
}