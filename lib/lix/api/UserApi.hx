package lix.api;

interface UserApi {
  @:get('/')
  function get():Promise<User>;
}