package lix.server.api;

import lix.api.ProjectsApi;
import lix.server.db.*;
import tink.sql.Expr;

class ProjectsApi extends BaseApi implements lix.api.ProjectsApi {
  
  var cond:Condition = true;
  
  public function list(?filter:ProjectFilter, ?limit:Limit):Promise<Array<ProjectDescription>> {
    return this.filter(filter, limit)
      .next(function(rows):Array<ProjectDescription> {
        return [for(row in rows) {
          id: row.project.id,
          owner: row.owner.name,
          name: row.project.name,
          description: row.project.description,
          url: row.project.url,
          tags: row.tags.map(tag -> tag.tag),
          deprecated: row.project.deprecated,
          authors: [], // TODO
        }];
      });
  }
  
  public function byId(id:String) {
    return new ProjectApi(switch (id:tink.Stringly).parseInt() {
      case Success(int): Id(int);
      case Failure(_): Slug(id);
    });
  }
  
  function filter(filter:ProjectFilter, limit:Limit) {
    return db.Project
      .leftJoin(db.Owner).on(Owner.id == Project.owner)
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where({
        var cond = this.cond;
        if(filter != null) {
          if(filter.tags != null && filter.tags.length > 0) cond = cond && ProjectTag.tag.inArray(filter.tags);
          if(filter.textSearch != null) cond = cond && Project.name.like('%${filter.textSearch}%');
        }
        cond;
      })
      .limit(limit)
      .all()
      .next(organize);
  }
  
  function organize(rows:Array<{Owner:Owner, Project:Project, ProjectTag:ProjectTag}>):Array<{owner:Owner, project:Project, tags:Array<ProjectTag>}> {
    var map = new Map();
    for(row in rows) {
      if(!map.exists(row.Project.id)) map[row.Project.id] = {owner: row.Owner, project: row.Project, tags: []}
      if(row.ProjectTag != null) map[row.Project.id].tags.push(row.ProjectTag);
    }
    return [for(project in map) project];
  }
}