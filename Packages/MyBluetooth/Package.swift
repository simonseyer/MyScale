// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MyBluetooth",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MyBluetooth",
            targets: ["MyBluetooth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manolofdez/AsyncBluetooth", from: "1.9.0")
    ],
    targets: [
        .target(
            name: "MyBluetooth",
            dependencies: ["AsyncBluetooth"]),
        .testTarget(
            name: "MyBluetoothTests",
            dependencies: ["MyBluetooth"]),
    ]
)
