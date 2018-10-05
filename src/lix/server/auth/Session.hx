package lix.server.auth;

import lix.server.db.*;
import tink.http.Request;
import haxe.crypto.Base64;
import haxe.Json;
import haxe.DynamicAccess;

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
          var payload:DynamicAccess<String> = Json.parse(Base64.decode(token.split('.')[1]).toString());
          switch payload['custom:lix_userid'] {
            case null | Std.parseInt(_) => null: Promise.lift(new Error(Unauthorized, 'Invalid token'));
            case Std.parseInt(_) => id: Promise.lift(Some(new AuthUser(id)));
          }
        } catch(e:Dynamic) {
          Promise.lift(Error.withData(Unauthorized, 'Invalid token', e));
        }
      case Success(Basic(username, password)):
        new Error(BadRequest, 'Basic authorization is not supported');
      #if ((environment == "test") || (environment == "local"))
      case Success(Others('Direct', Std.parseInt(_) => id)) if(id != null): 
          Some(new AuthUser(id));
      #end
      case Success(Others(scheme, param)): 
        new Error(BadRequest, 'Unsupported authorization header "$scheme $param"');
      case Failure(_):
        None;
    }
  }
  
}