package lix.server.api;

import lix.api.OAuthApi;
import lix.server.util.Password;
import tink.http.Fetch.fetch;

class OAuthApi extends BaseApi implements lix.api.OAuthApi {
  
  static var GITHUB_APP_ID = 'bef02a0cfa55650c58af';
  static var GITHUB_APP_SECRET = Sys.getEnv('GITHUB_APP_SECRET');
  
  public function new() {}
  
  public function githubAuthorize(action:OAuthAction):tink.Url {
    return 'https://github.com/login/oauth/authorize?client_id=$GITHUB_APP_ID&state=${randomString()}&redirect_uri=http://localhost:1234/oauth/github/callback?action=$action';
  }
  
  public function githubCallback(code:String, state:String, action:OAuthAction):Promise<OutgoingResponse> {
    return fetch('https://github.com/login/oauth/access_token?client_id=$GITHUB_APP_ID&client_secret=$GITHUB_APP_SECRET&code=$code&state=$state?redirect_uri=http://localhost:1234', {
      method: POST,
      headers: [new HeaderField(ACCEPT, 'application/json')],
    }).all()
      .next(function(req) return tink.Json.parse((req.body.toString():GithubToken)))
      .next(function(token) return redirect(action, 'github_token=${token.access_token}'));
      // .next(function(token) {
      //   return fetch('https://api.github.com/user', {
      //     headers: [
      //       new HeaderField('user-agent', 'Lix'),
      //       new HeaderField(AUTHORIZATION, 'token ${token.access_token}'),
      //       new HeaderField(ACCEPT, 'application/json'),
      //     ],
      //   }).all();
      // })
      // .next(function(req) return tink.Json.parse((req.body:GithubProfile)));
  }
  
  static function redirect(action:OAuthAction, query:String) {
    return new OutgoingResponse(
      new ResponseHeader(302, 'Found', [new HeaderField(LOCATION, 'https://lix.pm/$action?$query')]),
      tink.io.Source.EMPTY
    );
  }
  
  static function randomString()
    return haxe.crypto.Sha1.encode('${Date.now().getTime()}${Math.random()}');
  
}

private typedef GithubToken = {
  access_token:String,
  token_type:String,
}