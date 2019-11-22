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
import Foundation
import Rainbow

/// Type that encapsulates the configuration and evaluation of the `version` subcommand.
struct VersionCommand: CommandProtocol {
    typealias Options = NoOptions
    typealias ClientError = ModuleInterface.Error

    let verb = "version"
    let function = "Display the current version of ModuleInterface"

    func run(_: NoOptions<ModuleInterface.Error>) -> Result<Void, ModuleInterface.Error> {
        fputs("ModuleInterface v\(ModuleInterface.version)\n".cyan, stdout)
        return .success(())
    }
}
