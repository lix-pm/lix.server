package lix.api.auth;

interface AuthUser {
  var id(default, null):String;
  function hasRole(target:Target, role:Role):Promise<Bool>;
}

enum Target {
  Owner(owner:OwnerName);
  Project(owner:OwnerName, project:ProjectName);
}
