package lix.server.db;

typedef ProjectVersion = {
  @:primary final project:Id<Project>;
  @:primary final version:VarChar<255>;
  final haxe:VarChar<1000>;
  final published:DateTime;
  final deprecated:Bool;
}