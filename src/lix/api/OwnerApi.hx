package lix.api;

interface OwnerApi {
  @:sub
  function projects():ProjectsApi;
}