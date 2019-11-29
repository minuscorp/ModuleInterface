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

struct CleanCommandOptions: OptionsProtocol {
    let outputFolder: String
    let moduleName: String

    static func evaluate(_ mode: CommandMode) -> Result<CleanCommandOptions, CommandantError<ModuleInterface.Error>> {
        curry(self.init)
            <*> mode <| Option(key: "output-folder", defaultValue: ModuleInterface.defaultOutputPath, usage: "Output directory (defaults to \(ModuleInterface.defaultOutputPath)).")
            <*> mode <| Argument(usage: "The module's interface name to clean.")
    }
}

struct CleanCommand: CommandProtocol {
    typealias Options = CleanCommandOptions

    let verb: String = "clean"
    let function: String = "Deletes the module's interface and quits."

    func run(_ options: CleanCommandOptions) -> Result<Void, ModuleInterface.Error> {
        do {
            try Self.removeModuleInterface(path: options.outputFolder, module: options.moduleName)
            return .success(())
        } catch {
            return .failure(.default(error.localizedDescription))
        }
    }

    static func removeModuleInterface(path: String, module: String) throws {
        let file = path + "/" + (module.contains(".swift") ? module : module + ".swift")
        if FileManager.default.fileExists(atPath: file) {
            fputs("Removing module interface at \(file)".green, stdout)
            do {
                try FileManager.default.removeItem(atPath: file)
                fputs("\t✅\n", stdout)
            } catch {
                fputs("\t❌\n", stdout)
                throw error
            }
        } else {
            fputs("Did not find \(module) at \(path) to delete.\n".cyan, stdout)
        }
    }
}
