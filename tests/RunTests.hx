package;

import tink.testrunner.*;
import tink.unit.*;

class RunTests {
  static function main() {
    Runner.run(TestBatch.make([
      new UserTest(),
      new ProjectTest(),
      new VersionTest(),
    ])).handle(Runner.exit);
  }
}