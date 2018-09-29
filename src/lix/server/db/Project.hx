package lix.server.db;

typedef Project = {
  @:primary @:autoIncrement var id(default, never):Id<Project>;
  var name(default, never):VarChar<255>;
  var owner(default, never):Id<Owner>;
  @:optional var description(default, never):VarChar<1024>;
  @:optional var url(default, never):VarChar<1024>;
  var deprecated(default, never):Bool;
}