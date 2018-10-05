package lix.server.auth;

import jsonwebtoken.*;
import jsonwebtoken.crypto.*;
import jsonwebtoken.verifier.*;
import lix.server.db.*;
import lix.util.Config.*;
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
        verifyToken(token).next(payload -> {
          switch (cast payload:DynamicAccess<String>)['custom:lix_userid'] {
            case null | Std.parseInt(_) => null: Promise.lift(new Error(Unauthorized, 'Required attribute missing'));
            case Std.parseInt(_) => id: Promise.lift(Some(new AuthUser(id)));
          }
        });
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
  
  static var jwk:Promise<Map<String, String>>;
  static function verifyToken(token:String):Promise<Claims> {
    if(jwk == null)
      jwk = tink.http.Fetch.fetch('https://cognito-idp.$COGNITO_POOL_REGION.amazonaws.com/$COGNITO_POOL_ID/.well-known/jwks.json').all()
        .next(res -> tink.Json.parse((res.body:{keys:Array<{kid:String, n:String, e:String, kty:String, use:String}>})))
        .next(o -> [for(e in o.keys) e.kid => js.Lib.require('jwk-to-pem')(e)]);
    
    return jwk.next(keys -> {
      switch Codec.decode(token) {
        case Success({a: header, b: body}):
          switch keys[header.kid] {
            case null:
              new Error('key not found');
            case key:
              var crypto = new NodeCrypto();
              var verifier = new BasicVerifier(
                RS256({publicKey: key}),
                crypto,
                {iss: 'https://cognito-idp.$COGNITO_POOL_REGION.amazonaws.com/$COGNITO_POOL_ID'}
              );
              verifier.verify(token);
          }
        case Failure(e):
          e;
      }
    });
  }
}