package lix.server.api;

import lix.server.db.*;
import lix.api.OwnerProjectsApi;

class OwnerProjectsApi extends ProjectsApi implements lix.api.OwnerProjectsApi {
  var owner:OwnerName;
  
  public function new(owner) {
    super();
    this.owner = owner;
    this.cond = db.Owner.fields.name == owner;
  }
  
  public function create(data:NewProjectData) {
    return db.Owner.where(Owner.name == owner).first()
      .next(o -> {
        db.Project.insertOne({
          id: null,
          name: data.name,
          owner: o.id,
          description: data.description,
          url: data.url,
          deprecated: false,
        });
      })
      // TODO handle authors
      .next((id:tink.sql.Types.Id<lix.server.db.Project>) -> {
        switch data.tags {
          case null | []: id;
          case tags: 
            db.ProjectTag.insertMany([for(tag in tags) {
              project: id,
              tag: tag,
            }]).swap(id);
        }
      })
      .next(id -> byName(data.name))
      .next(project -> project.info());
  }
  
  public function byName(name:ProjectName):lix.api.ProjectApi
    return new ProjectApi(Slug('$owner/$name'));
  
  public function canCreate(user:AuthUser):Promise<Bool> {
    return user.hasRole(Owner(owner), Admin);
  }
}