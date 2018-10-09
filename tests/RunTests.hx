package;

import tink.testrunner.*;
import tink.unit.*;

class RunTests {
  static function main() {
    Boot.init();
    Runner.run(TestBatch.make([
      new UserTest(),
      new ProjectTest(),
      new VersionTest(),
    ])).handle(Runner.exit);
  }
}