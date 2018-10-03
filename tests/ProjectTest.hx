package;

import deepequal.DeepEqual.compare;

@:tink
@:asserts
class ProjectTest extends BaseTest {
  public function createWithoutTags() {
    var username = 'my_username';
    var name = 'project-name';
    
    Promise.inSequence([
      async(
        () -> UserTest.createUser({username: username})
      ),
      async(
        () -> createProject(username, {name: name}),
        project => asserts.assert(project.name == name)
      ),
      async(
        () -> db.Project.where(Project.name == name).count(),
        count => asserts.assert(count == 1)
      ),
      async(
        // list all projects
        () -> new OwnerProjectsApi(username).list(),
        projects => asserts.assert(projects.length == 1)
      ),
      async(
        // filter with tag
        () -> new OwnerProjectsApi(username).list({tags: ['dummy']}),
        projects => asserts.assert(projects.length == 0)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function createWithTags() {
    var username = 'my_username';
    var name = 'project-name';
    var tags = ['tag1', 'tag2'];
    
    Promise.inSequence([
      async(
        () -> UserTest.createUser({username: username})
      ),
      async(
        () -> createProject(username, {name: name, tags: tags}), 
        project => asserts.assert(compare(tags, project.tags))
      ),
      async(
        // check Project table
        () -> db.Project.where(Project.name == name).count(), 
        count => asserts.assert(count == 1)
      ),
      async(
        // check ProjectTag table
        () -> db.Project
          .leftJoin(db.ProjectTag).on(Project.id == ProjectTag.project)
          .where(Project.name == name).count(), 
        count => asserts.assert(count == 2)
      ),
      async(
        // list all projects
        () -> new OwnerProjectsApi(username).list(),
        projects => asserts.assert(projects.length == 1)
      ),
      async(
        // filter with tag
        () -> new OwnerProjectsApi(username).list({tags: ['dummy']}),
        projects => asserts.assert(projects.length == 0)
      ),
      async(
        // filter with tag
        () -> new OwnerProjectsApi(username).list({tags: ['tag1']}),
        projects => asserts.assert(projects.length == 1)
      ),
      async(
        // should not appear under another owner
        () -> new OwnerProjectsApi(username + 'another').list(),
        projects => asserts.assert(projects.length == 0)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public function createAsNonExistentOwner() {
    var username = 'my_username';
    var name = 'project-name';
    var owner = 'whatever';
    
    Promise.inSequence([
      async(
        () -> UserTest.createUser({username: username})
      ),
      asyncError(
        // 404 owner not found
        () -> createProject(owner, {name: name}), 
        e => asserts.assert(e.code == 404)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public static function createProject(owner:String, data = {name: 'project-name', url:(null:String), description:(null:String), tags:(null:Array<String>)}) {
    return new OwnerProjectsApi(owner).create(data);
  }
}