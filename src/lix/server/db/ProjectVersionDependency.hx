package lix.server.db;

typedef ProjectVersionDependency = {
  @:primary final project:Id<Project>;
  @:primary final version:VarChar<255>;
  @:primary final name:VarChar<1000>;
  final constraint:VarChar<1000>;
}