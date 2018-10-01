package lix.api;

interface Root {
  @:sub
  function owners():OwnersApi;
  @:sub
  function users():UsersApi;
  @:sub
  function projects():ProjectsApi;
  @:sub
  function oauth2():OAuthApi;
  @:sub
  function me(user:AuthUser):UserApi;
  @:get
  function version():{hash:String, buildDate:String};
}