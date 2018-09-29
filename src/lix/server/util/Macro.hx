package lix.server.util;

import haxe.macro.Context;

class Macro {
	public static macro function getBuildDate() {
		var offset = try new Date(1970, 0, 1, 0, 0, 0).getTime() catch (e:Dynamic) 0;
		var now = DateTools.delta(Date.now(), offset); // make it UTC
		return macro $v{now.toString() + ' (UTC)'};
	}
	
	public static macro function getGitSha() {
		#if !display
			var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
			return macro $v{process.stdout.readLine()};
		#else 
			// `#if display` is used for code completion. In this case returning an
			// empty string is good enough; We don't want to call git on every hint.
			return macro '';
		#end
	}
	
	public static macro function getDefine(name:String)
		return macro $v{Context.definedValue(name)}
}