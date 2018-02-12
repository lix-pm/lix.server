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
        [] => UserTest.createUser({username: username})
      ),
      async(
        [] => createProject(username, {name: name}),
        project => asserts.assert(project.name == name)
      ),
      async(
        [] => db.Project.where(Project.name == name).count(),
        count => asserts.assert(count == 1)
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
        [] => UserTest.createUser({username: username})
      ),
      async(
        [] => createProject(username, {name: name, tags: tags}), 
        project => asserts.assert(compare(tags, project.tags))
      ),
      async(
        [] => db.Project.where(Project.name == name).count(), 
        count => asserts.assert(count == 1)
      ),
      async(
        [] => db.Project
          .leftJoin(db.ProjectTag).on(Project.id == ProjectTag.project)
          .where(Project.name == name).count(), 
        count => asserts.assert(count == 2)
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
        [] => UserTest.createUser({username: username})
      ),
      asyncError(
        [] => createProject(owner, {name: name}), 
        e => asserts.assert(e.code == 404)
      ),
    ]).handle(asserts.handle);
    return asserts;
  }
  
  public static function createProject(owner:String, data = {name: 'project-name', url:(null:String), description:(null:String), tags:(null:Array<String>)}) {
    return new ProjectsApi(Owner(owner)).create(data);
  }
}