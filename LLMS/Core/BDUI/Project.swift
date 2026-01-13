import ProjectDescription

let project = Project(
    name: "BDUI",
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .exact(Version(10, 4, 0))),
    ],
    targets: [
        .target(
            name: "BDUI",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "dev.tuist.API",
            sources: ["BDUI/Sources/**"],
            resources: ["BDUI/Resources/**"],
            dependencies: [
                .package(product: "FirebaseFirestore"),
            ],
            settings: .settings(
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            ),
        )
    ]
)

