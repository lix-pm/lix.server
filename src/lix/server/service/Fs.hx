package lix.server.service;

using tink.CoreApi;
using tink.io.Sink;
using tink.io.Source;

interface Fs {
	function exists(path:String):Promise<Bool>;
	function read(path:String):RealSource;
	function write(path:String):RealSink;
	function delete(path:String):Promise<Noise>;
	function getDownloadUrl(path:String):Promise<String>;
	function getUploadUrl(path:String):Promise<String>;
}