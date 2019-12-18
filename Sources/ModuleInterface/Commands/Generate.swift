/*
 Copyright [2019] [Jorge Revuelta Herrero]

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Commandant
import Curry
import Foundation
import Rainbow
import SourceKittenFramework
import SwiftFormat

struct GenerateCommandOptions: OptionsProtocol {
    let spmModule: String?
    let moduleName: String?
    let inputFolder: String
    let outputFolder: String
    let minimumAccessLevel: String
    let clean: Bool
    let xcodeArguments: [String]

    static func evaluate(_ mode: CommandMode) -> Result<GenerateCommandOptions, CommandantError<ModuleInterface.Error>> {
        curry(self.init)
            <*> mode <| Option(key: "spm-module",
                               defaultValue: nil,
                               usage: "Generate documentation for Swift Package Manager module.")
            <*> mode <| Option(key: "module-name",
                               defaultValue: nil,
                               usage: "Generate documentation for a Swift module.")
            <*> mode <| Option(key: "input-folder",
                               defaultValue: FileManager.default.currentDirectoryPath,
                               usage: "Path to the input directory (defaults to \(FileManager.default.currentDirectoryPath)).")
            <*> mode <| Option(key: "output-folder",
                               defaultValue: ModuleInterface.defaultOutputPath,
                               usage: "Output directory (defaults to \(ModuleInterface.defaultOutputPath)).")
            <*> mode <| Option(key: "min-acl",
                               defaultValue: AccessLevel.public.rawValue,
                               usage: "The minimum access level to generate documentation. Defaults to \(AccessLevel.public.rawValue).")
            <*> mode <| Switch(flag: "c",
                               key: "clean",
                               usage: "Delete output folder before generating documentation.")
            <*> mode <| Argument(defaultValue: [],
                                 usage: "List of arguments to pass to xcodebuild.")
    }
}

struct GenerateCommand: CommandProtocol {
    typealias Options = GenerateCommandOptions

    let verb: String = "generate"
    let function: String = "Generates the Swift Module Interface."

    func run(_ options: GenerateCommandOptions) -> Result<Void, ModuleInterface.Error> {
        do {
            if let module = options.spmModule {
                let docs = try parseSPMModule(moduleName: module)
                try generateDocumentation(docs: docs, options: options, module: module)
            } else if let module = options.moduleName {
                let docs = try parseSwiftModule(moduleName: module, args: options.xcodeArguments,
                                                path: options.inputFolder)
                try generateDocumentation(docs: docs, options: options, module: module)
            } else {
                let docs = try parseXcodeProject(args: options.xcodeArguments, inputPath: options.inputFolder)
                try generateDocumentation(docs: docs, options: options, module: "")
            }
            return Result.success(())
        } catch let error as ModuleInterface.Error {
            return Result.failure(error)
        } catch {
            return Result.failure(ModuleInterface.Error.default(error.localizedDescription))
        }
    }

    private func interfaceForModule(_ module: String, compilerArguments: [String]) throws -> [String: SourceKitRepresentable] {
        try Request.customRequest(request: [
            "key.request": UID("source.request.editor.open.interface"),
            "key.name": NSUUID().uuidString,
            "key.compilerargs": compilerArguments,
            "key.modulename": "\(module)",
        ]).send()
    }

    private func parseSPMModule(moduleName: String) throws -> [String: SourceKitRepresentable] {
        guard let module = Module(spmName: moduleName) else {
            let message = "Error: Failed to generate documentation for SPM module '\(moduleName)'."
            throw ModuleInterface.Error.default(message)
        }
        return try interfaceForModule(module.name, compilerArguments: module.compilerArguments)
    }

    private func parseSwiftModule(moduleName: String, args: [String], path: String) throws -> [String: SourceKitRepresentable] {
        guard let module = Module(xcodeBuildArguments: args, name: moduleName, inPath: path) else {
            let message = "Error: Failed to generate documentation for module '\(moduleName)'."
            throw ModuleInterface.Error.default(message)
        }
        return try interfaceForModule(module.name, compilerArguments: module.compilerArguments)
    }

    private func parseXcodeProject(args: [String], inputPath: String) throws -> [String: SourceKitRepresentable] {
        guard let module = Module(xcodeBuildArguments: args, name: nil, inPath: inputPath) else {
            throw ModuleInterface.Error.default("Error: Failed to generate documentation.")
        }
        return try interfaceForModule(module.name, compilerArguments: module.compilerArguments)
    }

    fileprivate func documentate(_ sourcetext: String, module: String, options: GenerateCommandOptions) throws {
        let output = sourcetext
        try createDirectory(path: options.outputFolder)
        try write(to: options.outputFolder, module: module, documentation: output)
    }

    private func generateDocumentation(docs: [String: SourceKitRepresentable], options: GenerateCommandOptions, module: String) throws {
        if options.clean {
            try CleanCommand.removeModuleInterface(path: options.outputFolder, module: module)
        }
        if let sourcetext = docs["key.sourcetext"] as? String {
            try documentate(sourcetext, module: module, options: options)
        } else if let dictionary = docs["key.annotations"] as? SwiftDoc, let sourcetext = process(dictionary: dictionary, options: options) {
            try documentate(sourcetext, module: module, options: options)
        } else {
            let message = "Unable to parse module named \(module)"
            throw ModuleInterface.Error.default(message)
        }
    }

    private func write(to path: String, module: String, documentation: String) throws {
        fputs("Generating Module Interface...\n".green, stdout)
        let fileName = module.isEmpty ? "Unknown" : module
        let fileExtension = ".swift"
        let contents = documentation
        try contents.write(toFile: path + "/" + fileName + fileExtension, atomically: true, encoding: .utf8)
        fputs("Fomatting...\n".green, stdout)
        let formatted = try format(contents)
        try formatted.write(toFile: path + "/" + fileName + fileExtension, atomically: true, encoding: .utf8)
        fputs("Done 🎉\n".green, stdout)
    }

    private func createDirectory(path: String) throws {
        guard !path.isEmpty else {
            return
        }
        if !FileManager.default.fileExists(atPath: path) {
            try FileManager.default.createDirectory(atPath: path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
    }

    private func process(docs: [SwiftDocs], options: GenerateCommandOptions) -> [String] {
        let dictionaries = docs.compactMap { $0.docsDictionary.bridge() as? SwiftDoc }
        return process(dictionaries: dictionaries, options: options)
    }

    private func process(dictionaries: [SwiftDoc], options: GenerateCommandOptions) -> [String] {
        dictionaries.compactMap { process(dictionary: $0, options: options) }
    }

    private func process(dictionary: SwiftDoc, options: GenerateCommandOptions) -> String? {
        var doc: String = ""
        if dictionary.keys.contains(SwiftDocKey.kind.rawValue) {
            if let value: String = dictionary.get(.kind) {
                if case .enumcase = SwiftDeclarationKind(rawValue: value), let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDoc] {
                    return zip(substructure, substructure).compactMap { (decl: SwiftDoc, doc: SwiftDoc) -> String? in
                        if let declaration: String = decl.get(.parsedDeclaration), let doc: String = doc.get(.documentationComment) {
                            let formattedDoc = doc.split(separator: "\n").map { "/// \($0)" }.joined(separator: "\n")
                            return "/// \(formattedDoc)\n\(declaration)"
                        }
                        return nil
                    }
                    .joined(separator: "\n")
                }
            }
            let minimumAccessLevel = AccessLevel(rawValue: options.minimumAccessLevel) ?? .public
            guard let element = ModuleElement(dictionary: dictionary) else { return nil }
            guard element.dictionary.accessLevel >= minimumAccessLevel else { return nil }
            guard let declaration = element.declaration else { return nil }
            // https://github.com/jpsim/SourceKitten/issues/633
            guard isBalanced(sequence: declaration) else { return nil }

            // Step 1: Documentation
            if let docs = element.docs {
                doc += docs.split(separator: "\n").map { "/// \($0)" }.joined(separator: "\n")
                doc += "\n"
            }
            // Step 2: Declaration
            fputs("\(declaration) ✔\n".green, stdout)
            doc += declaration
            doc += "\n"
            // Step 3: Substructure
            if !element.subscructure.isEmpty, element.isTopLevelDeclaration {
                doc += " {\n"
                doc += process(dictionaries: element.subscructure, options: options).joined(separator: "\n")
                doc += "\n}\n"
            }
            return doc
        }
        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDoc] {
            return process(dictionaries: substructure, options: options).joined(separator: "\n") + "\n"
        }
        return nil
    }

    private func isBalanced(sequence: String) -> Bool {
        var stack = [Character]()
        for bracket in sequence {
            switch bracket {
            case "{", "[", "(":
                stack.append(bracket)
            case "}", "]", ")":
                if stack.isEmpty
                    || (bracket == "}" && stack.last != "{")
                    || (bracket == "]" && stack.last != "[")
                    || (bracket == ")" && stack.last != "(") {
                    return false
                }
                stack.removeLast()
            default:
                break
            }
        }
        return stack.isEmpty
    }
}
