package lix.server.service;

using tink.CoreApi;
using tink.io.Sink;
using tink.io.Source;

interface Fs {
	function read(path:String):RealSource;
	function write(path:String):RealSink;
	function delete(path:String):Promise<Noise>;
	function publicUrl(path:String):Promise<String>;
}