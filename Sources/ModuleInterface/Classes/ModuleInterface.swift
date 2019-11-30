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

struct ModuleInterface {
    enum Error: Swift.Error {
        case `default`(String)

        var localizedDescription: String {
            if case let .default(description) = self {
                return description
            }
            fatalError()
        }
    }

    static let version: String = "0.0.3"
    static let defaultOutputPath = "Documentation"

    func run() {
        let registry = CommandRegistry<Self.Error>()
        registry.register(CleanCommand())
        registry.register(GenerateCommand())
        registry.register(VersionCommand())
        registry.register(HelpCommand(registry: registry))

        registry.main(defaultVerb: "help") { error in
            fputs("\(error.localizedDescription)\n".red, stderr)
        }
    }
}
