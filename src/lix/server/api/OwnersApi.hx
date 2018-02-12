package lix.server.api;

class OwnersApi extends BaseApi implements lix.api.OwnersApi {
  
  public function create(data:{name:OwnerName, admin:Int}) {
    // TODO: transaction
    return db.Owner.insertOne({
      id: null,
      name: data.name
    })
      .next(function(id) {
        return db.OwnerRole.insertOne({
          user: data.admin,
          owner: id,
          role: Admin,
        })
          .swap({
            id: id,
            name: data.name
          });
      });
  }
  
  public function byName(name:OwnerName) return new OwnerApi(name);
}