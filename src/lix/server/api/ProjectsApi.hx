package lix.server.api;

import lix.api.ProjectsApi;
import tink.sql.Expr;

class ProjectsApi extends ProjectSearchApi implements lix.api.ProjectsApi {
  var owner:String;
  public function new(owner:String) {
    super();
    this.owner = owner;
    this.cond = db.Owner.name == owner;
  }
    
  public function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>})
    return 
      db.Owner.where(Owner.name == owner).first()
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
        .next(function(id) return byName(data.name))
        .next(function(project) return project.info());
  
  public function byName(name:ProjectName):Promise<lix.api.ProjectApi> 
    return (new ProjectApi(owner, name):lix.api.ProjectApi);
}