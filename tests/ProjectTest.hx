package;

import deepequal.DeepEqual.compare;

@:tink
@:asserts
class ProjectTest extends BaseTest {
  public function createWithoutTags() {
    var username = 'my_username';
    var name = 'project-name';
    var userId;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        () -> remote(userId).me().owner().projects().create({name: name}),
        project -> {
          asserts.assert(project.id > 0);
          asserts.assert(project.owner == username);
          asserts.assert(project.name == name);
        }
      ),
      async(
        () -> db.Project.where(Project.name == name).count(),
        count -> asserts.assert(count == 1)
      ),
      async(
        // list all projects
        () -> new OwnerProjectsApi(username).list(),
        projects -> asserts.assert(projects.length == 1)
      ),
      async(
        // filter with tag
        () -> new OwnerProjectsApi(username).list({tags: ['dummy']}),
        projects -> asserts.assert(projects.length == 0)
      ),
      async(
        // should not appear under another owner
        () -> new OwnerProjectsApi(username + 'another').list(),
        projects -> asserts.assert(projects.length == 0)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function createWithTags() {
    var username = 'my_username';
    var name = 'project-name';
    var tags = ['tag1', 'tag2'];
    var userId;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      async(
        () -> remote(userId).me().owner().projects().create({name: name, tags: tags}), 
        project -> asserts.assert(compare(tags, project.tags))
      ),
      async(
        // check Project table
        () -> db.Project.where(Project.name == name).count(), 
        count -> asserts.assert(count == 1)
      ),
      async(
        // check ProjectTag table
        () -> db.Project
          .leftJoin(db.ProjectTag).on(Project.id == ProjectTag.project)
          .where(Project.name == name).count(), 
        count -> asserts.assert(count == 2)
      ),
      async(
        // list all projects
        () -> new OwnerProjectsApi(username).list(),
        projects -> asserts.assert(projects.length == 1)
      ),
      async(
        // filter with wrong tag
        () -> new OwnerProjectsApi(username).list({tags: ['dummy']}),
        projects -> asserts.assert(projects.length == 0)
      ),
      async(
        // filter with tag
        () -> new OwnerProjectsApi(username).list({tags: ['tag1']}),
        projects -> asserts.assert(projects.length == 1)
      ),
      async(
        // should not appear under another owner
        () -> new OwnerProjectsApi(username + 'another').list(),
        projects -> asserts.assert(projects.length == 0)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function createAsNonExistentOwner() {
    var username = 'my_username';
    var name = 'project-name';
    var owner = 'whatever';
    var userId;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username}),
        user -> userId = user.id
      ),
      asyncError(
        // 403 forbidden 
        // TODO: should it be 404?
        () -> remote(userId).owners().byName(owner).projects().create({name: name}), 
        e -> asserts.assert(e.code == 403)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function createAsAnotherOwner() {
    var username1 = 'my_username1';
    var username2 = 'my_username2';
    var name = 'project-name';
    var userId1, userId2;
    
    Promise.inSequence([
      async(
        () -> Helper.createUser({username: username1}),
        user -> userId1 = user.id
      ),
      async(
        () -> Helper.createUser({username: username2}),
        user -> userId2 = user.id
      ),
      asyncError(
        // 403 forbidden
        () -> remote(userId1).owners().byName(username2).projects().create({name: name}), 
        e -> asserts.assert(e.code == 403)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
}