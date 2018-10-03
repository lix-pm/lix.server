package lix.server.db;

typedef ProjectVersion = {
  final project:Id<Project>;
  final version:VarChar<255>;
  final haxe:VarChar<1000>;
  final dependencies:VarChar<1000>;
  final published:DateTime;
  final deprecated:Bool;
}