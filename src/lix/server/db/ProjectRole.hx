package lix.server.db;

import lix.api.types.*;

typedef ProjectRole = {
  @:primary final user:Id<User>;
  @:primary final project:Id<Project>;
  final role:Role;
}