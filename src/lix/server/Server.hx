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

    new NodeContainer(1234).run(function (req:IncomingRequest) {
      return r.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
    });

    trace('running');

    var db = new Db('lix', new tink.sql.drivers.MySql({ user: 'root', password: '' }));
    db.Project.where(Project.id == 'tink_core').all().handle(function (x) trace(x));
  }
}
