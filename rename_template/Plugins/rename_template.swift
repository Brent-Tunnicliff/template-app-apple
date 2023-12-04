import Foundation
import PackagePlugin

private let oldName = "REPLACE_ME"

@main
struct rename_template: CommandPlugin {
    private static let newNameArgument = "name"

    // Entry point for command plugins applied to Swift Packages.
    func performCommand(context: PluginContext, arguments: [String]) async throws {
//        let files = context.package.targets.reduce(into: [Path]()) { partialResult, target in
//            let paths = target.sourceModule?.sourceFiles.map(\.path)
//            partialResult.append(contentsOf: paths ?? [])
//        }
//
//        try rename(files: files)

        try renameFiles(at: context.package.directory)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension rename_template: XcodeCommandPlugin {
    // Entry point for command plugins applied to Xcode projects.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
//        try rename(files: context.xcodeProject.filePaths.compactMap {
//            $0.string.contains("DerivedData") ? nil : $0
//        })

        try renameFiles(at: context.xcodeProject.directory)
    }
}

#endif

private extension rename_template {
    private static let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .isRegularFileKey]

    func renameFiles(at path: Path) throws {
        Diagnostics.remark("Checking files at \(path.string)")

        guard let url = URL(string: path.string) else {
            Diagnostics.error("Invalid url \(path.string)")
            return
        }

        let files = getFiles(at: url)

        Diagnostics.remark("Listing files:")
        for file in files {
            Diagnostics.remark("\t\(file.url.absoluteString)")
        }
    }

    private func getFiles(at path: URL) -> [PathType] {
        var files: [PathType] = []

        guard
            let enumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: Self.resourceKeys)
        else {
            Diagnostics.error("Unable to process files in \(path.absoluteString)")
            return []
        }

        for case let file as URL in enumerator {
            do {
                let fileAttributes = try file.resourceValues(forKeys: Set(Self.resourceKeys))
                guard fileAttributes.isDirectory == true else {
                    if fileAttributes.isRegularFile == true {
                        files.append(.file(file))
                    }
                    continue
                }

                files.append(.directory(file))
                files.append(contentsOf: getFiles(at: path))
            } catch {
                Diagnostics.error("Checking file \(file.absoluteString) filed with error \(String(describing: error))")
            }
        }

        return files
    }
}

private enum PathType {
    case directory(URL)
    case file(URL)

    var contentsNeedEditing: Bool {
        switch self {
        case .directory:
            return false
        case .file:
            do {
                let contentsOfFile = try String(contentsOf: url)
                return contentsOfFile.contains(oldName)
            } catch {
                Diagnostics.error("Failed to check file contents: \(url.absoluteString)")
                return false
            }
        }
    }

    var needsToBeRenamed: Bool {
        url.lastPathComponent.contains(oldName)
    }

    var url: URL {
        switch self {
        case let .directory(url):
            return url
        case let .file(url):
            return url
        }
    }
}

//    func rename(files: [Path]) throws {
//        guard !files.isEmpty else {
//            Diagnostics.error("No files to process")
//            return
//        }
//
//        // Edit contents of files
//        try files
//            .filter(doesFileContentsContainOldName)
//            .forEach(editContents)
//
//        try files.forEach { path in
//            Diagnostics.remark("Processing file \(path.string)")
//            _ = try doesFileContentsContainOldName(for: path)
//        }
//    }
//
//    private func doesFileContentsContainOldName(for file: Path) throws -> Bool {
//        Diagnostics.remark("Checking contents of file \(file.string)")
//        guard file.isSupported else {
//            Diagnostics.remark("Unable to check contents of \(file.string)")
//            return false
//        }
//
//        let contentsOfFile = try String(contentsOfFile: file.string)
//        return contentsOfFile.contains(Self.oldName)
//    }
//
//    private func editContents(of file: Path) {
//        Diagnostics.remark("Editing contents of file \(file)")
//
//        // TODO: edit file
//    }
//
//    /// Checks the name of the current file plus any parent directories.
//    private func getNamesToChange(from path: Path) -> [Path] {
//        guard path.string.contains(Self.oldName) else {
//            return []
//        }
//
//        let parentDirectoryPaths = getNamesToChange(from: path.removingLastComponent())
//        let file = path.lastComponent.contains(Self.oldName) ? [path] : []
//
//        // Rename self before parents.
//        return file + parentDirectoryPaths
//    }
//}

//private extension Path {
//    private static let unsupportedFileExtensions = [
//        "xcassets"
//    ]
//
//    var isSupported: Bool {
//        guard let `extension` = self.extension else {
//            return true
//        }
//
//        return !Self.unsupportedFileExtensions.contains(`extension`)
//    }
//}
