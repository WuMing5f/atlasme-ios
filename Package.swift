// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AtlasMe",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AtlasMe", targets: ["AtlasMe"])
    ],
    targets: [
        .target(name: "AtlasMe", path: "AtlasMe")
    ]
)

