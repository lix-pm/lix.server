package lix.server.db;

typedef ProjectTag = {
  @:primary final project:Id<Project>;
  @:primary final tag:VarChar<255>;
}