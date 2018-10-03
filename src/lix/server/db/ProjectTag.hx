package lix.server.db;

typedef ProjectTag = {
  final project:Id<Project>;
  final tag:VarChar<255>;
}