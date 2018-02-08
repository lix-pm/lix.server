package lix.server;

import lix.server.api.*;
import lix.server.db.*;
import tink.semver.*;
import tink.http.Request;
import tink.http.Response;
import tink.http.containers.*;
import tink.web.routing.*;

class Server {
  static function main() {
    
    var r = new Router<lix.api.Root>(new Root());
    var port = switch Sys.getEnv('PORT') {
      case null: 1234;
      case v: Std.parseInt(v);
    }
    
    new NodeContainer(port).run(function (req:IncomingRequest) {
      return r.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
    });

    trace('running');
  }
}
