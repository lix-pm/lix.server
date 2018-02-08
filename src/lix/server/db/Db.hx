package lix.server.db;

@:tables(Project, User, ProjectVersion, ProjectTag, ProjectContributor)
class Db extends tink.sql.Database {
}