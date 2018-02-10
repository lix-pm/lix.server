package lix.server.db;

import lix.api.types.*;

typedef ProjectRole = {
  @:primary var user(default, never):Id<User>;
  @:primary var owner(default, never):VarChar<255>;
  @:primary var project(default, never):VarChar<255>;
  var role(default, never):Role;
}