package lix.api.types;

typedef ProjectInfo = {
  >ProjectDescription, 
  final versions:Array<ProjectData>;
}