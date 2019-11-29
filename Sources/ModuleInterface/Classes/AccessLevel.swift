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

enum AccessLevel: String, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case open

    init(accessiblityKey: String?) {
        switch accessiblityKey {
        case .some("source.lang.swift.accessibility.private"):
            self = .private
        case .some("source.lang.swift.accessibility.fileprivate"):
            self = .fileprivate
        case .some("source.lang.swift.accessibility.internal"):
            self = .internal
        case .some("source.lang.swift.accessibility.public"):
            self = .public
        case .some("source.lang.swift.accessibility.open"):
            self = .open
        default:
            self = .private
        }
    }

    var priority: Int {
        switch self {
        case .private:
            return 0
        case .fileprivate:
            return 1
        case .internal:
            return 2
        case .public:
            return 3
        case .open:
            return 4
        }
    }
}

extension AccessLevel: Comparable, Equatable {
    static func < (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        lhs.priority < rhs.priority
    }

    static func == (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        lhs.priority == rhs.priority
    }
}
