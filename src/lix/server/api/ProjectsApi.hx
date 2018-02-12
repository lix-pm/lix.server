package lix.server.api;

import lix.api.ProjectsApi;
import tink.sql.Expr;

class ProjectsApi extends BaseApi implements lix.api.ProjectsApi {
  public var scope(default, null):Scope;
  
  public function new(scope) {
    super();
    this.scope = scope;
  }
    
  public function create(data:{name:String, ?url:String, ?description:String, ?tags:Array<String>}) {
    return switch scope {
      case Owner(owner):
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
      case Global:
        Promise.lift(new Error(BadRequest, 'Cannot create project in global scope'));
    }
  }

  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> {
    return db.Project
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where({
        var cond = EValue(true, VBool);
        if(filter.tags != null && filter.tags.length > 0) cond = cond && ProjectTag.tag.inArray(filter.tags);
        if(filter.textSearch != null) cond = cond && Project.name.like('%${filter.textSearch}%');
        cond;
      })
      .all()
      .next(function(o):Array<ProjectDescription> {
        var ret = new Map();
        for(o in o) {
          var project = o.Project;
          if(!ret.exists(project.id)) {
            ret[project.id] = {
              name: project.name,
              description: project.description,
              tags: [],
              deprecated: project.deprecated,
              authors: [], // TODO
            }
          }
          ret[project.id].tags.push(o.ProjectTag.tag);
        }
        return [for(project in ret) project];
      });
  }
  
  public function byName(name:ProjectName):Promise<lix.api.ProjectApi> {
    return switch scope {
      case Owner(owner):
        (new ProjectApi(owner, name):lix.api.ProjectApi);
      case Global:
        new Error(BadRequest, 'Cannot access project "$name" in global scope');
    }
  }
}