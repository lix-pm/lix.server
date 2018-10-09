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
import tink.web.proxy.Remote.RemoteEndpoint;
import tink.url.Host;

class BaseTest {
  var db = Boot.db;
  var fs = Boot.fs;
  var client = Boot.client;
  
  public function new() {}
  
  @:before
  public function init() {
    return Promise.inParallel([
      fs.delete('/').recover(_ -> Noise),
      db.destroy().flatMap(_ -> db.init()),
    ]);
  }
  
  function remote(?id:Int) {
    return new tink.web.proxy.Remote<lix.api.Root>(
      id == null ? client : new TestClient(client, id),
      new RemoteEndpoint(new Host('localhost', 1))
    );
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
  
  inline function path(id, ver)
    return Boot.path(id, ver);
  
}

class TestClient implements ClientObject {
  var id:Int;
  var proxy:Client;
  
  public function new(proxy, id) {
    this.proxy = proxy;
    this.id = id;
  }
  
  public function request(req:OutgoingRequest):Promise<IncomingResponse> {
    return proxy.request(new OutgoingRequest(
      req.header.concat([new HeaderField(AUTHORIZATION, 'Direct $id')]),
      req.body
    ));
  }
}