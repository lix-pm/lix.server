package lix.server.db;

typedef User = {
  @:primary @:autoIncrement var id(default, never):Id<User>;
  @:unique var username(default, never):VarChar<255>;
  @:unique var cognitoId(default, never):VarChar<255>;
  @:optional var nickname(default, never):VarChar<255>;
}