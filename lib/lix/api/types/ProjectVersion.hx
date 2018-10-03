package lix.api.types;

typedef ProjectVersion = {
  var version(default, never):Version;
  var dependencies(default, never):Array<Dependency>;
  var haxe(default, never):Constraint;
  var published(default, never):Date;
  var deprecated(default, never):Bool;
}