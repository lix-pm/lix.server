package lix.server.api;

import lix.server.service.*;
import lix.server.service.fs.*;
import lix.server.db.*;


class BaseApi {
	
	var fs:Fs = #if (environment == "production") new S3('lix-production') #else new Local('./storage') #end ;
	var db = Db.get();
	
}