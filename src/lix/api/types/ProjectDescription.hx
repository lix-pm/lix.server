package lix.api.types;

typedef ProjectDescription = {
  var name(default, never):ProjectName;
  var description(default, never):String;
  var authors(default, never):Array<Author>;
  @:optional var tags(default, never):Array<Tag>;
  @:optional var deprecated(default, never):Bool;
}