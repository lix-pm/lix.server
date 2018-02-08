package lix.server.db;

typedef Project = {
  var id(default, never):VarChar<255>;
  var deprecated(default, never):Boolean;
}