package lix.server.api;

class OwnersApi extends BaseApi implements lix.api.OwnersApi {
  
  public function create(name:OwnerName, user:AuthUser) {
    // TODO: transaction
    return db.Owner.insertOne({
      id: null,
      name: name
    })
      .next(id -> {
        db.OwnerRole.insertOne({
          user: user.id,
          owner: id,
          role: Admin,
        })
          .swap({
            id: id,
            name: name
          });
      });
  }
  
  public function byName(name:OwnerName)
    return new OwnerApi(name);
}