package lix.api.types;

enum ProjectIdentifier {
  Id(id:Int);
  Slug(slug:String);
}

enum SanitizedProjectIdentifier {
  Id(id:Int);
  Name(owner:OwnerName, name:ProjectName);
}

class ProjectIdentifierTools {
  public static function sanitize(raw:ProjectIdentifier):Outcome<SanitizedProjectIdentifier, Error> {
    return switch raw {
      case Id(id): Success(Id(id));
      case Slug(_.split('/') => [owner, name]): Success(Name(owner, name));
      case Slug(slug): Failure(new Error(BadRequest, 'Invalid slug "$slug"'));
    }
  }
}