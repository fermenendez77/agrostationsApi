// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "AgroStationsApi",
    products: [
        .library(name: "AgroStationsApi", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0")
        
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor","FluentPostgreSQL","Leaf", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

