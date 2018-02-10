package lix.server.api;

class ProjectsApi extends BaseApi implements lix.api.ProjectsApi {
  var owner:OwnerName;
  
  public function new(owner)
    this.owner = owner;
    
  public function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}) {
    return db.Owner.where(Owner.name == owner).first()
      .next(function(o) {
        return db.Project.insertOne({
          id: null,
          name: data.name,
          owner: o.id,
          description: data.description,
          url: data.url,
          deprecated: false,
        });
      })
      .next(function(id:tink.sql.Types.Id<lix.server.db.Project>) {
        return switch data.tags {
          case null | []: id;
          case tags: 
            db.ProjectTag.insertMany([for(tag in tags) {
              project: id,
              tag: tag,
            }]).swap(id);
        }
      })
      .next(function(id) return byName(data.name).info());
  }

  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> return [];
  
  public function byName(name:ProjectName):ProjectApi {
    return new ProjectApi(owner, name);
  }
}