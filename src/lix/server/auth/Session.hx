package lix.server.auth;

import why.Auth;
import why.auth.TinkWebAuth;
import lix.util.Config.*;

using tink.CoreApi;

class Session {
  var auth:Auth<AuthUser>;
  
  public function new(header) {
    auth = new TinkWebAuth(header, [
      #if ((environment == "test") || (environment == "local"))
      new DirectProvider(id -> switch Std.parseInt(id) {
        case null: None;
        case id: Some(new AuthUser(id));
      }),
      #end
      new CognitoProvider({
        makeUser: profile -> switch profile['custom:lix_userid'] {
          case null | Std.parseInt(_) => null: Promise.lift(new Error(Unauthorized, 'Required attribute missing from the token'));
          case Std.parseInt(_) => id: Promise.lift(Some(new AuthUser(id)));
        },
        region: COGNITO_POOL_REGION,
        poolId: COGNITO_POOL_ID,
        clientId: COGNITO_CLIENT_ID,
      })
    ]); 
  }
    
  public function getUser():Promise<Option<AuthUser>> {
    return auth.authenticate();
  }
}
