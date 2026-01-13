import ProjectDescription

let workspace = Workspace(
    name: "LLMS",
    projects: [
        .relativeToRoot("Application/LLMS"),
        .relativeToRoot("Core/API")
    ]
)
