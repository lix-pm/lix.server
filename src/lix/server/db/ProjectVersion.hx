package lix.server.db;

typedef ProjectVersion = {
  final project:Id<Project>;
  final version:VarChar<255>;
  final published:DateTime;
  final deprecated:Bool;
}