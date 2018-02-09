package lix.server.db;

import tink.sql.drivers.MySql;

@:tables(Project, User, ProjectVersion, ProjectTag, ProjectContributor)
class Db extends tink.sql.Database {
	
	static var inst:Db;
	public static function get() {
		if(inst == null) {
			switch Sys.getEnv('DATABASE_URL') {
				case null:
					var driver = new MySql({user: 'root', password: ''});
					inst = new Db('lix', driver);
				case v:
					var url = tink.Url.parse(v);
					var driver = new MySql({user: url.auth.user, password: url.auth.password, host: url.host.name, port: url.host.port});
					inst = new Db(url.path.toString().substr(1), driver);
			}
		}
		return inst;
	}
}