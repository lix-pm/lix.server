package lix.util;

import tink.url.*;

class Config {
  public static inline var API_SERVER_SCHEME =
    #if ((environment == "local") || (environment == "test"))
      'http';
    #elseif (environment == "prod")
      'https';
    #end
    
  public static inline var API_SERVER_HOSTNAME = 
    #if ((environment == "local") || (environment == "test"))
      'localhost';
    #elseif (environment == "prod")
      'api.lix.pm';
    #end
    
  public static inline var API_SERVER_PORT = 
    #if ((environment == "local") || (environment == "test"))
      1234;
    #elseif (environment == "prod")
      null;
    #end
    
  public static var API_SERVER_HOST = new Host(API_SERVER_HOSTNAME, API_SERVER_PORT);
  public static var API_SERVER_URL = API_SERVER_SCHEME + '://' + API_SERVER_HOST;
  
  public static inline var SITE_SCHEME =
    #if ((environment == "local") || (environment == "test"))
      'http';
    #elseif (environment == "prod")
      'https';
    #end
    
  public static inline var SITE_HOSTNAME = 
    #if ((environment == "local") || (environment == "test"))
      'localhost';
    #elseif (environment == "prod")
      'lix.pm';
    #end
    
  public static inline var SITE_PORT = 
    #if ((environment == "local") || (environment == "test"))
      2010;
    #elseif (environment == "prod")
      null;
    #end
    
  public static var SITE_HOST = new Host(SITE_HOSTNAME, SITE_PORT);
  public static var SITE_URL = SITE_SCHEME + '://' + SITE_HOST;
  
  public static inline var COGNITO_POOL_REGION = 'us-east-2';
  public static inline var COGNITO_POOL_ID = 'us-east-2_qNnxj1mU1';
  public static inline var COGNITO_CLIENT_ID = 'fvrf50i7h5od9nr1bq4pefcg3';
}