package lix.server.db;

typedef Owner = {
  @:primary @:autoIncrement final id:Id<Owner>;
  @:unique final name:VarChar<255>;
}