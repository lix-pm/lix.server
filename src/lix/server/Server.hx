package lix.server;

import lix.server.api.Root;
import lix.server.auth.Session;
import lix.server.db.*;
import lix.util.Config.*;
import tink.semver.*;
import tink.http.Request;
import tink.http.Response;
import tink.http.Container;
import tink.http.Handler;
import tink.http.containers.*;
import tink.http.middleware.*;
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
    var handler:Handler = req -> r.route(Context.authed(req, Session.new)).recover(OutgoingResponse.reportError);
    handler = handler.applyMiddleware(new Log());
    container.run(handler).eager();
    
    // init / update db (TODO: this shouldn't be here)
    var db = Db.get();
    db.init().flatMap(_ -> db.updateSchema()).eager();
    
    trace('running');
  }
}

