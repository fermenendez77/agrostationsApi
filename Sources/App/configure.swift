import FluentMySQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(AuthenticationProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let databaseConfig = MySQLDatabaseConfig(hostname : "localhost",
                                             username: "agroadmindb",
                                             password: "agro",
                                             database: "agrostations")
    
    let database = MySQLDatabase(config: databaseConfig)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: database, as: .mysql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Station.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    migrations.add(model: Measurement.self, database: .mysql)
    services.register(migrations)
}
