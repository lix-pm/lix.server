package lix.server.auth;

import lix.server.db.*;
import lix.server.util.*;
import tink.http.Request;
import haxe.crypto.Base64;
import haxe.Json;

using tink.CoreApi;

class Session {
  var header:IncomingRequestHeader;
  var db = Db.get();
  
  public function new(header)
    this.header = header;
    
  public function getUser():Promise<Option<AuthUser>> {
    return switch header.getAuth() {
      case Success(Bearer(token)):
        try {
          var id = Json.parse(Base64.decode(token.split('.')[1]).toString()).sub;
          Promise.lift(Some(new AuthUser(id)));
        } catch(e:Dynamic) {
          Promise.lift(Error.withData('Invalid token', e));
        }
      case Success(Basic(username, password)):
        new Error(BadRequest, 'Basic authorization is not supported');
      case Success(Others(scheme, params)): 
        new Error(BadRequest, 'Unsupported authorization header "$scheme $params"');
      case Failure(_):
        None;
    }
  }
  
}