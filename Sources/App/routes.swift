import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let userController = UserController()
    try router.register(collection: userController)
    
    let stationsController = StationController()
    try router.register(collection: stationsController)
}
