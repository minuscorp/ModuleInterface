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

import Foundation
import SourceKittenFramework

typealias SwiftDoc = [String: Any]

extension Dictionary where Key == String, Value == Any {
    func get<T>(_ key: SwiftDocKey) -> T? {
        self[key.rawValue] as? T
    }

    var accessLevel: AccessLevel {
        let accessiblityKey = self["key.accessibility"] as? String
        return AccessLevel(accessiblityKey: accessiblityKey)
    }

    func isKind(of kind: SwiftDeclarationKind) -> Bool {
        SwiftDeclarationKind(rawValue: get(.kind) ?? "") == kind
    }

    func isKind(of kinds: SwiftDeclarationKind...) -> Bool {
        guard let value: String = get(.kind), let kind = SwiftDeclarationKind(rawValue: value) else {
            return false
        }
        return kinds.contains(kind)
    }
}

protocol SwiftDocInitializable {
    var dictionary: SwiftDoc { get }

    init?(dictionary: SwiftDoc)
}

extension SwiftDocInitializable {
    var docs: String? {
        dictionary.get(.documentationComment)
    }

    var declaration: String? {
        dictionary.get(.parsedDeclaration)
    }

    var subscructure: [SwiftDoc] {
        dictionary.get(.substructure) ?? []
    }

    var isTopLevelDeclaration: Bool {
        guard let value: String = dictionary.get(.kind) else { return false }
        let kind = SwiftDeclarationKind(rawValue: value)
        switch kind {
        case .struct, .class, .enum, .protocol, .extension, .extensionClass, .extensionEnum, .extensionProtocol, .extensionStruct:
            return true
        default:
            return false
        }
    }
}

struct ModuleElement: SwiftDocInitializable {
    let dictionary: SwiftDoc

    init?(dictionary: SwiftDoc) {
        self.dictionary = dictionary
    }
}
