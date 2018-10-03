package;

import lix.server.db.*;
import lix.server.api.*;
import lix.server.auth.*;
import tink.http.containers.*;
import tink.http.clients.*;
import tink.http.Response;
import tink.http.Request;
import tink.http.Header;
import tink.http.Client;
import tink.web.routing.*;
import tink.web.proxy.Remote;
import tink.url.Host;

class BaseTest {
  var db = Db.get();
  var client:Client;
  
  public function new() {
    var router = new Router<Session, lix.api.Root>(new Root());
    var container = new LocalContainer();
    client = new LocalContainerClient(container);
    container.run(req -> router.route(Context.authed(req, Session.new)).recover(OutgoingResponse.reportError)).eager();
  }
  
  @:before
  public function init() {
    return Promise.inParallel([
      @:privateAccess new BaseApi().fs.delete('/').recover(function(_) return Noise),
      db.destroy().flatMap(_ -> db.init()),
    ]);
  }
  
  function remote(userId:Int) {
    return new Remote<lix.api.Root>(client, new RemoteEndpoint(new Host('localhost', 1)));
  }
  
  function async<T>(promise:Void->Promise<T>, ?assert:T->Void) {
    return Promise.lazy(promise).next(v -> {
        if(assert != null) assert(v);
        Noise;
      });
  }
  
  function asyncError<T>(promise:Void->Promise<T>, ?assert:Error->Void) {
    return Promise.lazy(promise).map(o -> switch o {
        case Success(_): Failure(new Error('Expected Failure but got Success'));
        case Failure(e): assert(e); Success(Noise);
      });
  }
}

class TestClient implements ClientObject {
  var userId:Int;
  var proxy:Client;
  
  public function new(userId, proxy) {
    this.userId = userId;
    this.proxy = proxy;
  }
  
  public function request(req:OutgoingRequest):Promise<IncomingResponse> {
    return proxy.request(new OutgoingRequest(
      req.header.concat([new HeaderField(AUTHORIZATION, 'Direct $userId')]),
      req.body
    ));
  }
}