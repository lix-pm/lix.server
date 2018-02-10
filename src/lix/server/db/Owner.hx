package lix.server.db;

typedef Owner = {
  @:primary @:autoIncrement var id(default, never):Id<Owner>;
  var name(default, never):VarChar<255>;
}