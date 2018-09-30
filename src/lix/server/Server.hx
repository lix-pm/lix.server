package lix.server;

import lix.server.api.Root;
import lix.server.auth.Session;
import lix.server.db.*;
import lix.util.Config.*;
import tink.semver.*;
import tink.http.Request;
import tink.http.Response;
import tink.http.Container;
import tink.http.containers.*;
import tink.web.routing.Router;
import tink.web.routing.Context;

class Server {
  
  #if aws_lambda
    @:expose('index') @:keep
    static function index(event, ctx, cb) {
      ctx.callbackWaitsForEmptyEventLoop = false;
      run(new AwsLambdaNodeContainer(event, ctx, cb));
    }
  #else
    static function main() {
      run(new NodeContainer(API_SERVER_PORT));
    }
  #end
  
  static function run(container:Container) {
    var r = new Router<Session, LocalRoot>(new Root());
    container.run(function (req:IncomingRequest) {
      return r.route(Context.authed(req, Session.new)).recover(OutgoingResponse.reportError);
    });
    
    // init / update db (TODO: this shouldn't be here)
    var db = Db.get();
    db.init().flatMap(function(o) return db.updateSchema()).eager();
    
    trace('running');
  }
}

