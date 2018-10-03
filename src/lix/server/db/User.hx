package lix.server.db;

typedef User = {
  @:primary @:autoIncrement final id:Id<User>;
  @:unique final username:VarChar<255>;
  @:unique final cognitoId:VarChar<255>;
  @:optional final nickname:VarChar<255>;
}