import ProjectDescription

let project = Project(
    name: "LLMS",
    packages: [
        .local(path: "/Users/tagirfajrusin/Documents/SwiftProjects/OpenRouter"),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .exact(Version(10, 4, 0))),
        .remote(url: "https://github.com/Swinject/Swinject", requirement: .exact(Version(2, 8, 0)))
    ],
    targets: [
        .target(
            name: "LLMS",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.LLMS",
            infoPlist: .extendingDefault(with: [
                    "UILaunchScreen": [:]
                ]),
            sources: ["LLMS/Sources/**"],
            resources: ["LLMS/Resources/**"],
            dependencies: [
                .package(product: "OpenRouter"),
                .package(product: "Swinject"),
                .package(product: "FirebaseAnalytics"),
                .package(product: "FirebaseFirestore"),
                .package(product: "FirebaseCrashlytics"),
                .package(product: "FirebaseStorage"),
                .project(target: "BDUI", path: "../../Core/BDUI")
            ],
            settings: .settings(
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            ),
        ),
        .target(
            name: "LLMSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.LLMSTests",
            sources: ["LLMS/Tests/**"],
            dependencies: [.target(name: "LLMS")]
        ),
    ]
)
