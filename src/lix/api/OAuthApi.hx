package lix.api;

interface OAuthApi {
  @:get('/github/authorize')
  @:params(action in query)
  function githubAuthorize(action:OAuthAction):tink.Url;
  
  @:get('/github/callback')
  @:params(code in query)
  @:params(state in query)
  @:params(action in query)
  function githubCallback(code:String, state:String, action:OAuthAction):Promise<OutgoingResponse>;
}
