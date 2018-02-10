package lix.api.types;

typedef User = {
  var id(default, never):Int;
  var username(default, never):String;
  @:optional var nickname(default, never):String;
  @:optional var githubId(default, never):Int;
}