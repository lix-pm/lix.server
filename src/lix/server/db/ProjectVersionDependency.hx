package lix.server.db;

typedef ProjectVersionDependency = {
  @:primary final project:Id<Project>;
  @:primary final version:VarChar<255>;
  @:primary final name:VarChar<255>;
  final constraint:VarChar<255>;
}