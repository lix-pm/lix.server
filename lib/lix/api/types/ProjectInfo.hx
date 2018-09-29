package lix.api.types;

typedef ProjectInfo = {
  >ProjectDescription, 
  var versions(default, never):Array<ProjectData>;
}