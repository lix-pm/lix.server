package lix.server.api;

import lix.api.ProjectsApi;
import lix.server.db.*;
import tink.sql.Expr;

class ProjectsApi extends BaseApi implements lix.api.ProjectsApi {
  public function list(?filter:ProjectFilter):Promise<Array<ProjectDescription>> {
    return _list(filter)
      .next(function(o):Array<ProjectDescription> {
        var ret = new Map();
        for(o in o) {
          var project = o.project;
          if(!ret.exists(project.id)) {
            ret[project.id] = {
              name: project.name,
              description: project.description,
              tags: [],
              deprecated: project.deprecated,
              authors: [], // TODO
            }
          }
          if(o.projectTag != null)
            ret[project.id].tags.push(o.projectTag.tag);
        }
        return [for(project in ret) project];
      });
  }
  
  public function byId(id:String) {
    return new ProjectApi(switch (id:tink.Stringly).parseInt() {
      case Success(int): Id(int);
      case Failure(_): Slug(id);
    });
  }
  
  function _list(?filter:ProjectFilter):Promise<Array<{project:Project, projectTag:ProjectTag}>> {
    return db.Project
      .leftJoin(db.ProjectTag).on(ProjectTag.project == Project.id)
      .where({
        var cond:Condition = true;
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
}