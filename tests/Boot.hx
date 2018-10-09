package;

import lix.server.db.*;
import lix.server.api.*;
import lix.server.auth.*;
import tink.http.containers.*;
import tink.http.clients.*;
import tink.http.Response;
import tink.http.Request;
import tink.http.Header;
import tink.http.Handler;
import tink.http.Client;
import tink.http.middleware.*;
import tink.web.routing.*;
import tink.web.proxy.Remote;
import tink.url.Host;

class Boot {
  
  public static var db(default, null) = Db.get();
  public static var fs(default, null) = @:privateAccess new BaseApi().fs;
  public static var client(default, null):Client;
  
  public static function init() {
    var router = new Router<Session, lix.api.Root>(new Root());
    var container = new LocalContainer();
    client = new LocalContainerClient(container);
    var handler:Handler = req -> router.route(Context.authed(req, Session.new)).recover(OutgoingResponse.reportError);
    // handler = handler.applyMiddleware(new Log());
    container.run(handler).eager();
  }
  
  public static function path(id, ver)
    return @:privateAccess new BaseApi().path(id, ver);
}