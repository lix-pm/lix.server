package lix.server.db;

typedef Owner = {
  @:primary @:autoIncrement final id:Id<Owner>;
  final name:VarChar<255>;
}