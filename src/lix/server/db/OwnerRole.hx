package lix.server.db;

import lix.api.types.*;

typedef OwnerRole = {
  @:primary var user(default, never):Id<User>;
  @:primary var owner(default, never):VarChar<255>;
  var role(default, never):Role;
}