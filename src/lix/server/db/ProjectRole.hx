package lix.server.db;

import lix.api.types.*;

typedef ProjectRole = {
  @:primary var user(default, never):Id<User>;
  @:primary var project(default, never):Id<Project>;
  var role(default, never):Role;
}