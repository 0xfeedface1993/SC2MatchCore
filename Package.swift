// swift-tools-version:4.2
// Generated automatically by Perfect Assistant
// Date: 2019-05-07 01:06:42 +0000
import PackageDescription

let package = Package(
	name: "StarCraftMatchCore",
	products: [
		.library(name: "StarCraftMatchCore", targets: ["StarCraftMatchCore"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/SwiftORM/SQLite-StORM.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Notifications.git", "4.0.0"..<"5.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", "3.0.0"..<"4.0.0"),
		.package(url: "https://github.com/SwiftORM/Postgres-StORM.git", "3.2.1"..<"3.2.9223372036854775807")
	],
	targets: [
		.target(name: "StarCraftMatchCore", dependencies: ["PerfectHTTPServer", "PerfectNotifications", "SQLiteStORM", "PerfectLogger", "PostgresStORM"]),
		.testTarget(name: "StarCraftMatchCoreTests", dependencies: ["StarCraftMatchCore"])
	]
)
