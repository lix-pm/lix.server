package lix.server.db;

typedef ProjectVersion = {
  var project(default, never):Id<Project>;
  var version(default, never):VarChar<255>;
  var published(default, never):DateTime;
}