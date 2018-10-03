package lix.server.api;

import lix.server.db.*;

class OwnerProjectsApi extends ProjectsApi implements lix.api.OwnerProjectsApi {
  var owner:OwnerName;
  
  public function new(owner) {
    super();
    this.owner = owner;
  }
  
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
      .next(function(id) return byName(data.name))
      .next(function(project) return project.info());
  }
  
  public function byName(name:ProjectName):lix.api.ProjectApi {
    return new ProjectApi(owner, name);
  }
  
  override function _list(?filter:ProjectFilter) {
    return db.Project
      .leftJoin(db.Owner).on(Project.owner == Owner.id)
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where({
        var cond = Owner.name == owner;
        if(filter != null) {
          if(filter.tags != null && filter.tags.length > 0) cond = cond && ProjectTag.tag.inArray(filter.tags);
          if(filter.textSearch != null) cond = cond && Project.name.like('%${filter.textSearch}%');
        }
        cond;
      })
      .all()
      .next(function(res):Array<{project:Project, projectTag:ProjectTag}> {
        return [for(v in res) {
          project: v.Project,
          projectTag: v.ProjectTag
        }];
      });
  }
  
  public function canCreate(user:lix.api.auth.AuthUser):Promise<Bool> {
    return user.hasRole(Owner(owner), Admin);
  }
}