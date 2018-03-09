package lix.server.api;

import tink.sql.Expr;

class ProjectSearchApi extends BaseApi implements lix.api.ProjectSearchApi {
  var cond:Expr<Bool> = EValue(true, VBool);
  public function new() {
    super();
  }
  
  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> {
    return db.Project
      .leftJoin(db.Owner).on(Project.owner == Owner.id)
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where({
        var cond = this.cond;
        if(filter != null) {
          if(filter.tags != null && filter.tags.length > 0) cond = cond && ProjectTag.tag.inArray(filter.tags);
          if(filter.textSearch != null) cond = cond && Project.name.like('%${filter.textSearch}%');
        }
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
          if(o.ProjectTag != null)
            ret[project.id].tags.push(o.ProjectTag.tag);
        }
        return [for(project in ret) project];
      });
  }
}