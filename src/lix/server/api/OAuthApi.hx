package lix.server.api;

import lix.api.OAuthApi;
import lix.util.Config.*;
import lix.util.OAuthHelper;

class OAuthApi extends BaseApi implements lix.api.OAuthApi {
  
  public function authorize(?state:String):tink.Url {
    return OAuthHelper.authorize(state, AuthorizationCodeGrant, '$API_SERVER_URL/oauth2/callback');
  }
  
  public function callback(code:String, ?state:String, ?action:String):Promise<OutgoingResponse> {
    return OAuthHelper.callback(code, state, '$API_SERVER_URL/oauth2/callback')
      .next(token -> new Error('TODO'));
  }
}