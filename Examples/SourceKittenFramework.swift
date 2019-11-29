import Clang_C
import Dispatch
import Foundation
import SourceKit
import SwiftOnoneSupport
import SWXMLHash
import Yams

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func < (lhs: SourceKittenFramework.SourceDeclaration, rhs: SourceKittenFramework.SourceDeclaration) -> Bool

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func < (lhs: SourceKittenFramework.SourceLocation, rhs: SourceKittenFramework.SourceLocation) -> Bool

public func == (lhs: SourceKittenFramework.SourceLocation, rhs: SourceKittenFramework.SourceLocation) -> Bool

/**
 Returns true if `lhs` Structure is equal to `rhs` Structure.

 - parameter lhs: Structure to compare to `rhs`.
 - parameter rhs: Structure to compare to `lhs`.

 - returns: True if `lhs` Structure is equal to `rhs` Structure.
 */
public func == (lhs: SourceKittenFramework.Structure, rhs: SourceKittenFramework.Structure) -> Bool

/**
 Returns true if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.

 - parameter lhs: SyntaxMap to compare to `rhs`.
 - parameter rhs: SyntaxMap to compare to `lhs`.

 - returns: True if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.
 */
public func == (lhs: SourceKittenFramework.SyntaxMap, rhs: SourceKittenFramework.SyntaxMap) -> Bool

/**
 Returns true if `lhs` SyntaxToken is equal to `rhs` SyntaxToken.

 - parameter lhs: SyntaxToken to compare to `rhs`.
 - parameter rhs: SyntaxToken to compare to `lhs`.

 - returns: True if `lhs` SyntaxToken is equal to `rhs` SyntaxToken.
 */
public func == (lhs: SourceKittenFramework.SyntaxToken, rhs: SourceKittenFramework.SyntaxToken) -> Bool

public struct ClangAvailability {
    public let alwaysDeprecated: Bool

    public let alwaysUnavailable: Bool

    public let deprecationMessage: String?

    public let unavailableMessage: String?
}

/// Represents a group of CXTranslationUnits.
public struct ClangTranslationUnit {
    public let declarations: [String: [SourceKittenFramework.SourceDeclaration]]

    /**
     Create a ClangTranslationUnit by passing Objective-C header files and clang compiler arguments.

     - parameter headerFiles:       Objective-C header files to document.
     - parameter compilerArguments: Clang compiler arguments.
     */
    public init(headerFiles: [String], compilerArguments: [String])

    /**
     Failable initializer to create a ClangTranslationUnit by passing Objective-C header files and
     `xcodebuild` arguments. Optionally pass in a `path`.

     - parameter headerFiles:         Objective-C header files to document.
     - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to link these header files.
     - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
     */
    public init?(headerFiles: [String], xcodeBuildArguments: [String], inPath path: String = FileManager.default.currentDirectoryPath)
}

extension ClangTranslationUnit: CustomStringConvertible {
    /// A textual JSON representation of `ClangTranslationUnit`.
    public var description: String { get }
}

public struct CodeCompletionItem: CustomStringConvertible {
    public typealias NumBytesInt = Int64

    public let kind: String

    public let context: String

    public let name: String?

    public let descriptionKey: String?

    public let sourcetext: String?

    public let typeName: String?

    public let moduleName: String?

    public let docBrief: String?

    public let associatedUSRs: String?

    public let numBytesToErase: SourceKittenFramework.CodeCompletionItem.NumBytesInt?

    /// Dictionary representation of CodeCompletionItem. Useful for NSJSONSerialization.
    public var dictionaryValue: [String: Any] { get }

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }

    public static func parse(response: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SourceKittenFramework.CodeCompletionItem]
}

public struct Documentation {
    public let parameters: [SourceKittenFramework.Parameter]

    public let returnDiscussion: [SourceKittenFramework.Text]
}

/// Represents a source file.
public final class File {
    /// File path. Nil if initialized directly with `File(contents:)`.
    public let path: String?

    /// File contents.
    public var contents: String

    /// File lines.
    public var lines: [SourceKittenFramework.Line] { get }

    /**
     Failable initializer by path. Fails if file contents could not be read as a UTF8 string.

     - parameter path: File path.
     */
    public init?(path: String)

    public init(pathDeferringReading path: String)

    /**
     Initializer by file contents. File path is nil.

     - parameter contents: File contents.
     */
    public init(contents: String)

    /// Formats the file.
    ///
    /// - Parameters:
    ///   - trimmingTrailingWhitespace: Boolean
    ///   - useTabs: Boolean
    ///   - indentWidth: Int
    /// - Returns: formatted String
    /// - Throws: Request.Error
    public func format(trimmingTrailingWhitespace: Bool, useTabs: Bool, indentWidth: Int) throws -> String

    /**
     Parse source declaration string from SourceKit dictionary.

     - parameter dictionary: SourceKit dictionary to extract declaration from.

     - returns: Source declaration if successfully parsed.
     */
    public func parseDeclaration(_ dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> String?

    /**
     Parse line numbers containing the declaration's implementation from SourceKit dictionary.

     - parameter dictionary: SourceKit dictionary to extract declaration from.

     - returns: Line numbers containing the declaration's implementation.
     */
    public func parseScopeRange(_ dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> (start: Int, end: Int)?

    /**
     Returns a copy of the input dictionary with comment mark names, cursor.info information and
     parsed declarations for the top-level of the input dictionary and its substructures.

     - parameter dictionary:        Dictionary to process.
     - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
     */
    public func process(dictionary: [String: SourceKittenFramework.SourceKitRepresentable], cursorInfoRequest: SourceKittenFramework.SourceKitObject? = nil, syntaxMap: SourceKittenFramework.SyntaxMap? = nil) -> [String: SourceKittenFramework.SourceKitRepresentable]
}

extension File: Hashable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SourceKittenFramework.File, rhs: SourceKittenFramework.File) -> Bool

    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher)
}

/// File methods to generate and manipulate OffsetMap's.
extension File {
    /**
     Creates an OffsetMap containing offset locations at which there are declarations that likely
     have documentation comments, but haven't been documented by SourceKitten yet.

     - parameter documentedTokenOffsets: Offsets where there are declarations that likely
                                         have documentation comments.
     - parameter dictionary:             Docs dictionary to check for which offsets are already
                                         documented.

     - returns: OffsetMap containing offset locations at which there are declarations that likely
                have documentation comments, but haven't been documented by SourceKitten yet.
     */
    public func makeOffsetMap(documentedTokenOffsets: [Int], dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> SourceKittenFramework.OffsetMap
}

/// Language Enum.
public enum Language {
    /// Swift.
    case swift

    /// Objective-C.
    case objc
}

/// Representation of line in String
public struct Line {
    /// origin = 0
    public let index: Int

    /// Content
    public let content: String

    /// UTF16 based range in entire String. Equivalent to Range<UTF16Index>
    public let range: NSRange

    /// Byte based range in entire String. Equivalent to Range<UTF8Index>
    public let byteRange: NSRange
}

/// Represents source module to be documented.
public struct Module {
    /// Module Name.
    public let name: String

    /// Compiler arguments required by SourceKit to process the source files in this Module.
    public let compilerArguments: [String]

    /// Source files to be documented in this Module.
    public let sourceFiles: [String]

    /// Documentation for this Module. Typically expensive computed property.
    public var docs: [SourceKittenFramework.SwiftDocs] { get }

    public init?(spmName: String, inPath path: String = FileManager.default.currentDirectoryPath)

    /**
     Failable initializer to create a Module by the arguments necessary pass in to `xcodebuild` to build it.
     Optionally pass in a `moduleName` and `path`.

     - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this Module.
     - parameter name:                Module name. Will be parsed from `xcodebuild` output if nil.
     - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
     */
    public init?(xcodeBuildArguments: [String], name: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath)

    /**
     Initializer to create a Module by name and compiler arguments.

     - parameter name:              Module name.
     - parameter compilerArguments: Compiler arguments required by SourceKit to process the source files in this Module.
     */
    public init(name: String, compilerArguments: [String])
}

extension Module: CustomStringConvertible {
    /// A textual representation of `Module`.
    public var description: String { get }
}

/**
 Objective-C declaration kinds.
 More or less equivalent to `SwiftDeclarationKind`, but with made up values because there's no such
 thing as SourceKit for Objective-C.
 */
public enum ObjCDeclarationKind: String {
    /// `category`.
    case category

    /// `class`.
    case `class`

    /// `constant`.
    case constant

    /// `enum`.
    case `enum`

    /// `enumcase`.
    case enumcase

    /// `initializer`.
    case initializer

    /// `method.class`.
    case methodClass

    /// `method.instance`.
    case methodInstance

    /// `property`.
    case property

    /// `protocol`.
    case `protocol`

    /// `typedef`.
    case typedef

    /// `function`.
    case function

    /// `mark`.
    case mark

    /// `struct`
    case `struct`

    /// `field`
    case field

    /// `ivar`
    case ivar

    /// `ModuleImport`
    case moduleImport

    /// `UnexposedDecl`
    case unexposedDecl

    public init(_ cursorKind: CXCursorKind)
}

/// Type that maps potentially documented declaration offsets to its closest parent offset.
public typealias OffsetMap = [Int: Int]

public struct Parameter {
    public let name: String

    public let discussion: [SourceKittenFramework.Text]
}

/// Represents a SourceKit request.
public enum Request {
    /// An `editor.open` request for the given File.
    case editorOpen(file: SourceKittenFramework.File)

    /// A `cursorinfo` request for an offset in the given file, using the `arguments` given.
    case cursorInfo(file: String, offset: Int64, arguments: [String])

    /// A `cursorinfo` request for a USR in the given file, using the `arguments` given.
    case cursorInfoUSR(file: String, usr: String, arguments: [String], cancelOnSubsequentRequest: Bool)

    /// A custom request by passing in the `SourceKitObject` directly.
    case customRequest(request: SourceKittenFramework.SourceKitObject)

    /// A request generated by sourcekit using the yaml representation.
    case yamlRequest(yaml: String)

    /// A `codecomplete` request by passing in the file name, contents, offset
    /// for which to generate code completion options and array of compiler arguments.
    case codeCompletionRequest(file: String, contents: String, offset: Int64, arguments: [String])

    /// ObjC Swift Interface
    case interface(file: String, uuid: String, arguments: [String])

    /// Find USR
    case findUSR(file: String, usr: String)

    /// Index
    case index(file: String, arguments: [String])

    /// Format
    case format(file: String, line: Int64, useTabs: Bool, indentWidth: Int64)

    /// ReplaceText
    case replaceText(file: String, offset: Int64, length: Int64, sourceText: String)

    /// A documentation request for the given source text.
    case docInfo(text: String, arguments: [String])

    /// A documentation request for the given module.
    case moduleInfo(module: String, arguments: [String])

    /// Gets the serialized representation of the file's SwiftSyntax tree. JSON string if `byteTree` is false,
    /// binary data otherwise.
    case syntaxTree(file: SourceKittenFramework.File, byteTree: Bool)

    /**
     Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

     - returns: SourceKit output as a dictionary.
     - throws: Request.Error on fail ()
     */
    public func send() throws -> [String: SourceKittenFramework.SourceKitRepresentable]

    /// A enum representation of SOURCEKITD_ERROR_*
    public enum Error: Error, CustomStringConvertible {
        case connectionInterrupted(String?)

        case invalid(String?)

        case failed(String?)

        case cancelled(String?)

        case unknown(String?)

        /// A textual representation of `self`.
        public var description: String { get }
    }

    /**
     Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

     - returns: SourceKit output as a dictionary.
     - throws: Request.Error on fail ()
     */
    @available(*, deprecated, renamed: "send()")
    public func failableSend() throws -> [String: SourceKittenFramework.SourceKitRepresentable]
}

extension Request: CustomStringConvertible {
    /// A textual representation of `Request`.
    public var description: String { get }
}

/// Represents a source code declaration.
public struct SourceDeclaration {
    public let type: SourceKittenFramework.ObjCDeclarationKind

    public let location: SourceKittenFramework.SourceLocation

    public let extent: (start: SourceKittenFramework.SourceLocation, end: SourceKittenFramework.SourceLocation)

    public let name: String?

    public let usr: String?

    public let declaration: String?

    public let documentation: SourceKittenFramework.Documentation?

    public let commentBody: String?

    public var children: [SourceKittenFramework.SourceDeclaration]

    public let annotations: [String]?

    public let swiftDeclaration: String?

    public let swiftName: String?

    public let availability: SourceKittenFramework.ClangAvailability?

    /// Range
    public var range: NSRange { get }

    /// Returns the USR for the auto-generated getter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    public var getterUSR: String { get }

    /// Returns the USR for the auto-generated setter for this property.
    ///
    /// - warning: can only be invoked if `type == .Property`.
    public var setterUSR: String { get }
}

extension SourceDeclaration: Hashable {
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SourceKittenFramework.SourceDeclaration, rhs: SourceKittenFramework.SourceDeclaration) -> Bool
}

extension SourceDeclaration: Comparable {}

/// Swift representation of sourcekitd_object_t
public final class SourceKitObject {
    /// Updates the value stored in the dictionary for the given key,
    /// or adds a new key-value pair if the key does not exist.
    ///
    /// - Parameters:
    ///   - value: The new value to add to the dictionary.
    ///   - key: The key to associate with value. If key already exists in the dictionary,
    ///     value replaces the existing associated value. If key isn't already a key of the dictionary
    public func updateValue(_ value: SourceKittenFramework.SourceKitObjectConvertible, forKey key: SourceKittenFramework.UID)

    public func updateValue(_ value: SourceKittenFramework.SourceKitObjectConvertible, forKey key: String)

    public func updateValue<T>(_ value: SourceKittenFramework.SourceKitObjectConvertible, forKey key: T) where T: RawRepresentable, T.RawValue == String
}

extension SourceKitObject: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension SourceKitObject: CustomStringConvertible {
    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

extension SourceKitObject: ExpressibleByArrayLiteral {
    /// Creates an instance initialized with the given elements.
    public convenience init(arrayLiteral elements: SourceKittenFramework.SourceKitObject...)
}

extension SourceKitObject: ExpressibleByDictionaryLiteral {
    /// Creates an instance initialized with the given key-value pairs.
    public convenience init(dictionaryLiteral elements: (SourceKittenFramework.UID, SourceKittenFramework.SourceKitObjectConvertible)...)
}

extension SourceKitObject: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or
    /// constant using an integer literal. For example:
    ///
    ///     let x = 23
    ///
    /// In this example, the assignment to the `x` constant calls this integer
    /// literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public convenience init(integerLiteral value: IntegerLiteralType)
}

extension SourceKitObject: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public convenience init(stringLiteral value: StringLiteralType)
}

public protocol SourceKitObjectConvertible {
    var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

public protocol SourceKitRepresentable {
    func isEqualTo(_ rhs: SourceKittenFramework.SourceKitRepresentable) -> Bool
}

extension SourceKitRepresentable {
    public func isEqualTo(_ rhs: SourceKittenFramework.SourceKitRepresentable) -> Bool
}

public struct SourceLocation {
    public let file: String

    public let line: UInt32

    public let column: UInt32

    public let offset: UInt32

    public func range(toEnd end: SourceKittenFramework.SourceLocation) -> NSRange
}

extension SourceLocation: Comparable {}

/// Swift declaration kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.stmt.`.
public enum StatementKind: String {
    /// `brace`.
    case brace

    /// `case`.
    case `case`

    /// `for`.
    case `for`

    /// `foreach`.
    case forEach

    /// `guard`.
    case `guard`

    /// `if`.
    case `if`

    /// `repeatewhile`.
    case repeatWhile

    /// `switch`.
    case `switch`

    /// `while`.
    case `while`
}

/// Represents the structural information in a Swift source file.
public struct Structure {
    /// Structural information as an [String: SourceKitRepresentable].
    public let dictionary: [String: SourceKittenFramework.SourceKitRepresentable]

    /**
     Create a Structure from a SourceKit `editor.open` response.

     - parameter sourceKitResponse: SourceKit `editor.open` response.
     */
    public init(sourceKitResponse: [String: SourceKittenFramework.SourceKitRepresentable])

    /**
     Initialize a Structure by passing in a File.

     - parameter file: File to parse for structural information.
     - throws: Request.Error
     */
    public init(file: SourceKittenFramework.File) throws
}

extension Structure: CustomStringConvertible {
    /// A textual JSON representation of `Structure`.
    public var description: String { get }
}

extension Structure: Equatable {}

/// Swift declaration attribute kinds.
/// Found in `strings SourceKitService | grep source.decl.attribute.`.
public enum SwiftDeclarationAttributeKind: String, CaseIterable {
    case ibaction

    case iboutlet

    case ibdesignable

    case ibinspectable

    case gkinspectable

    case objc

    case objcName

    case silgenName

    case available

    case final

    case required

    case optional

    case noreturn

    case epxorted

    case nsCopying

    case nsManaged

    case lazy

    case lldbDebuggerFunction

    case uiApplicationMain

    case unsafeNoObjcTaggedPointer

    case inline

    case semantics

    case dynamic

    case infix

    case prefix

    case postfix

    case transparent

    case requiresStoredProperyInits

    case nonobjc

    case fixedLayout

    case inlineable

    case specialize

    case objcMembers

    case mutating

    case nonmutating

    case convenience

    case override

    case silStored

    case weak

    case effects

    case objcBriged

    case nsApplicationMain

    case objcNonLazyRealization

    case synthesizedProtocol

    case testable

    case alignment

    case `rethrows`

    case swiftNativeObjcRuntimeBase

    case indirect

    case warnUnqualifiedAccess

    case cdecl

    case versioned

    case discardableResult

    case implements

    case objcRuntimeName

    case staticInitializeObjCMetadata

    case restatedObjCConformance

    case `private`

    case `fileprivate`

    case `internal`

    case `public`

    case open

    case setterPrivate

    case setterFilePrivate

    case setterInternal

    case setterPublic

    case setterOpen

    case optimize

    case consuming

    case implicitlyUnwrappedOptional

    case underscoredObjcNonLazyRealization

    case clangImporterSynthesizedType

    case forbidSerializingReference

    case usableFromInline

    case weakLinked

    case inlinable

    case dynamicMemberLookup

    case frozen

    case autoclosure

    case noescape

    case __raw_doc_comment

    case __setter_access

    case _borrowed

    case _dynamicReplacement

    case _effects

    case _hasInitialValue

    case _hasStorage

    case _nonoverride

    case _private

    case _show_in_interface

    case dynamicCallable
}

/// Swift declaration kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.decl.`.
public enum SwiftDeclarationKind: String, CaseIterable {
    /// `associatedtype`.
    case `associatedtype`

    /// `class`.
    case `class`

    /// `enum`.
    case `enum`

    /// `enumcase`.
    case enumcase

    /// `enumelement`.
    case enumelement

    /// `extension`.
    case `extension`

    /// `extension.class`.
    case extensionClass

    /// `extension.enum`.
    case extensionEnum

    /// `extension.protocol`.
    case extensionProtocol

    /// `extension.struct`.
    case extensionStruct

    /// `function.accessor.address`.
    case functionAccessorAddress

    /// `function.accessor.didset`.
    case functionAccessorDidset

    /// `function.accessor.getter`.
    case functionAccessorGetter

    case functionAccessorModify

    /// `function.accessor.mutableaddress`.
    case functionAccessorMutableaddress

    case functionAccessorRead

    /// `function.accessor.setter`.
    case functionAccessorSetter

    /// `function.accessor.willset`.
    case functionAccessorWillset

    /// `function.constructor`.
    case functionConstructor

    /// `function.destructor`.
    case functionDestructor

    /// `function.free`.
    case functionFree

    /// `function.method.class`.
    case functionMethodClass

    /// `function.method.instance`.
    case functionMethodInstance

    /// `function.method.static`.
    case functionMethodStatic

    case functionOperator

    /// `function.operator.infix`.
    case functionOperatorInfix

    /// `function.operator.postfix`.
    case functionOperatorPostfix

    /// `function.operator.prefix`.
    case functionOperatorPrefix

    /// `function.subscript`.
    case functionSubscript

    /// `generic_type_param`.
    case genericTypeParam

    /// `module`.
    case module

    /// `precedencegroup`.
    case precedenceGroup

    /// `protocol`.
    case `protocol`

    /// `struct`.
    case `struct`

    /// `typealias`.
    case `typealias`

    /// `var.class`.
    case varClass

    /// `var.global`.
    case varGlobal

    /// `var.instance`.
    case varInstance

    /// `var.local`.
    case varLocal

    /// `var.parameter`.
    case varParameter

    /// `var.static`.
    case varStatic
}

/// SourceKit response dictionary keys.
public enum SwiftDocKey: String {
    /// Annotated declaration (String).
    case annotatedDeclaration

    /// Body length (Int64).
    case bodyLength

    /// Body offset (Int64).
    case bodyOffset

    /// Diagnostic stage (String).
    case diagnosticStage

    /// Elements ([[String: SourceKitRepresentable]]).
    case elements

    /// File path (String).
    case filePath

    /// Full XML docs (String).
    case fullXMLDocs

    /// Kind (String).
    case kind

    /// Length (Int64).
    case length

    /// Name (String).
    case name

    /// Name length (Int64).
    case nameLength

    /// Name offset (Int64).
    case nameOffset

    /// Offset (Int64).
    case offset

    /// Substructure ([[String: SourceKitRepresentable]]).
    case substructure

    /// Syntax map (NSData).
    case syntaxMap

    /// Type name (String).
    case typeName

    /// Inheritedtype ([SourceKitRepresentable])
    case inheritedtypes

    /// Column where the token's declaration begins (Int64).
    case docColumn

    /// Documentation comment (String).
    case documentationComment

    /// Declaration of documented token (String).
    case docDeclaration

    /// Discussion documentation of documented token ([SourceKitRepresentable]).
    case docDiscussion

    /// File where the documented token is located (String).
    case docFile

    /// Line where the token's declaration begins (Int64).
    case docLine

    /// Name of documented token (String).
    case docName

    /// Parameters of documented token ([SourceKitRepresentable]).
    case docParameters

    /// Parsed declaration (String).
    case docResultDiscussion

    /// Parsed scope start (Int64).
    case docType

    /// Parsed scope start end (Int64).
    case usr

    /// Result discussion documentation of documented token ([SourceKitRepresentable]).
    case parsedDeclaration

    /// Type of documented token (String).
    case parsedScopeEnd

    /// USR of documented token (String).
    case parsedScopeStart

    /// Swift Declaration (String).
    case swiftDeclaration

    /// Swift Name (String).
    case swiftName

    /// Always deprecated (Bool).
    case alwaysDeprecated

    /// Always unavailable (Bool).
    case alwaysUnavailable

    /// Always deprecated (String).
    case deprecationMessage

    /// Always unavailable (String).
    case unavailableMessage

    /// Annotations ([String]).
    case annotations
}

/// Represents docs for a Swift file.
public struct SwiftDocs {
    /// Documented File.
    public let file: SourceKittenFramework.File

    /// Docs information as an [String: SourceKitRepresentable].
    public let docsDictionary: [String: SourceKittenFramework.SourceKitRepresentable]

    /**
     Create docs for the specified Swift file and compiler arguments.

     - parameter file:      Swift file to document.
     - parameter arguments: compiler arguments to pass to SourceKit.
     */
    public init?(file: SourceKittenFramework.File, arguments: [String])

    /**
     Create docs for the specified Swift file, editor.open SourceKit response and cursor info request.

     - parameter file:              Swift file to document.
     - parameter dictionary:        editor.open response from SourceKit.
     - parameter cursorInfoRequest: SourceKit dictionary to use to send cursorinfo request.
     */
    public init(file: SourceKittenFramework.File, dictionary: [String: SourceKittenFramework.SourceKitRepresentable], cursorInfoRequest: SourceKittenFramework.SourceKitObject?)
}

extension SwiftDocs: CustomStringConvertible {
    /// A textual JSON representation of `SwiftDocs`.
    public var description: String { get }
}

/// Syntax kind values.
/// Found in `strings SourceKitService | grep source.lang.swift.syntaxtype.`.
public enum SyntaxKind: String {
    /// `argument`.
    case argument

    /// `attribute.builtin`.
    case attributeBuiltin

    /// `attribute.id`.
    case attributeID

    /// `buildconfig.id`.
    case buildconfigID

    /// `buildconfig.keyword`.
    case buildconfigKeyword

    /// `comment`.
    case comment

    /// `comment.mark`.
    case commentMark

    /// `comment.url`.
    case commentURL

    /// `doccomment`.
    case docComment

    /// `doccomment.field`.
    case docCommentField

    /// `identifier`.
    case identifier

    /// `keyword`.
    case keyword

    /// `number`.
    case number

    /// `objectliteral`
    case objectLiteral

    /// `parameter`.
    case parameter

    /// `placeholder`.
    case placeholder

    /// `string`.
    case string

    /// `string_interpolation_anchor`.
    case stringInterpolationAnchor

    /// `typeidentifier`.
    case typeidentifier

    /// `pounddirective.keyword`.
    case poundDirectiveKeyword
}

/// Represents a Swift file's syntax information.
public struct SyntaxMap {
    /// Array of SyntaxToken's.
    public let tokens: [SourceKittenFramework.SyntaxToken]

    /**
     Create a SyntaxMap by passing in tokens directly.

     - parameter tokens: Array of SyntaxToken's.
     */
    public init(tokens: [SourceKittenFramework.SyntaxToken])

    /**
     Create a SyntaxMap by passing in NSData from a SourceKit `editor.open` response to be parsed.

     - parameter data: NSData from a SourceKit `editor.open` response
     */
    public init(data: [SourceKittenFramework.SourceKitRepresentable])

    /**
     Create a SyntaxMap from a SourceKit `editor.open` response.

     - parameter sourceKitResponse: SourceKit `editor.open` response.
     */
    public init(sourceKitResponse: [String: SourceKittenFramework.SourceKitRepresentable])

    /**
     Create a SyntaxMap from a File to be parsed.

     - parameter file: File to be parsed.
     - throws: Request.Error
     */
    public init(file: SourceKittenFramework.File) throws
}

extension SyntaxMap: CustomStringConvertible {
    /// A textual JSON representation of `SyntaxMap`.
    public var description: String { get }
}

extension SyntaxMap: Equatable {}

/// Represents a single Swift syntax token.
public struct SyntaxToken {
    /// Token type. See SyntaxKind.
    public let type: String

    /// Token offset.
    public let offset: Int

    /// Token length.
    public let length: Int

    /// Dictionary representation of SyntaxToken. Useful for NSJSONSerialization.
    public var dictionaryValue: [String: Any] { get }

    /**
     Create a SyntaxToken by directly passing in its property values.

     - parameter type:   Token type. See SyntaxKind.
     - parameter offset: Token offset.
     - parameter length: Token length.
     */
    public init(type: String, offset: Int, length: Int)
}

extension SyntaxToken: Equatable {}

extension SyntaxToken: CustomStringConvertible {
    /// A textual JSON representation of `SyntaxToken`.
    public var description: String { get }
}

public enum Text {
    case para(String, String?)

    case verbatim(String)
}

/// Swift representation of sourcekitd_uid_t
public struct UID: Hashable {
    public init(_ string: String)

    public init<T>(_ rawRepresentable: T) where T: RawRepresentable, T.RawValue == String
}

extension UID: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension UID: CustomStringConvertible {
    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

extension UID: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String)
}

extension UID: SourceKittenFramework.UIDRepresentable {
    public var uid: SourceKittenFramework.UID { get }
}

public protocol UIDRepresentable {
    var uid: SourceKittenFramework.UID { get }
}

public struct Version {
    public let value: String

    public static let current: SourceKittenFramework.Version
}

public func declarationsToJSON(_ decl: [String: [SourceKittenFramework.SourceDeclaration]]) -> String

public func insertMarks(declarations: [SourceKittenFramework.SourceDeclaration], limit: NSRange? = nil) -> [SourceKittenFramework.SourceDeclaration]

/**
 Parse XML from `key.doc.full_as_xml` from `cursor.info` request.

 - parameter xmlDocs: Contents of `key.doc.full_as_xml` from SourceKit.

 - returns: XML parsed as an `[String: SourceKitRepresentable]`.
 */
public func parseFullXMLDocs(_ xmlDocs: String) -> [String: SourceKittenFramework.SourceKitRepresentable]?

/**
 Extracts Objective-C header files and `xcodebuild` arguments from an array of header files followed by `xcodebuild` arguments.

 - parameter sourcekittenArguments: Array of Objective-C header files followed by `xcodebuild` arguments.

 - returns: Tuple of header files and xcodebuild arguments.
 */
public func parseHeaderFilesAndXcodebuildArguments(sourcekittenArguments: [String]) -> (headerFiles: [String], xcodebuildArguments: [String])

public func sdkPath() -> String

/**
 JSON Object to JSON String.

 - parameter object: Object to convert to JSON.

 - returns: JSON string representation of the input object.
 */
public func toJSON(_ object: Any) -> String

/**
 Convert [String: SourceKitRepresentable] to `NSDictionary`.

 - parameter dictionary: [String: SourceKitRepresentable] to convert.

 - returns: JSON-serializable value.
 */
public func toNSDictionary(_ dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> NSDictionary

extension CXString: CustomStringConvertible {
    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String { get }
}

extension Dictionary where Key == String, Value == SourceKittenFramework.SourceKitRepresentable {
    public var referencedUSRs: [String] { get }
}

extension Array {
    public func bridge() -> NSArray
}

extension CharacterSet {
    public func bridge() -> NSCharacterSet
}

extension Dictionary {
    public func bridge() -> NSDictionary
}

extension NSString {
    public func bridge() -> String
}

extension String {
    public func bridge() -> NSString
}

extension Array: SourceKittenFramework.SourceKitRepresentable {}

extension Dictionary: SourceKittenFramework.SourceKitRepresentable {}

extension String: SourceKittenFramework.SourceKitRepresentable {}

extension Int64: SourceKittenFramework.SourceKitRepresentable {}

extension Bool: SourceKittenFramework.SourceKitRepresentable {}

extension Data: SourceKittenFramework.SourceKitRepresentable {}

extension Array: SourceKittenFramework.SourceKitObjectConvertible where Element: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension Dictionary: SourceKittenFramework.SourceKitObjectConvertible where Key: SourceKittenFramework.UIDRepresentable, Value: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension Int: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension Int64: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension String: SourceKittenFramework.SourceKitObjectConvertible {
    public var sourceKitObject: SourceKittenFramework.SourceKitObject? { get }
}

extension NSString {
    /**
     Returns line number and character for utf16 based offset.

     - parameter offset: utf16 based index.
     - parameter tabWidth: the width in spaces to expand tabs to.
     */
    public func lineAndCharacter(forCharacterOffset offset: Int, expandingTabsToWidth tabWidth: Int = 1) -> (line: Int, character: Int)?

    /**
     Returns line number and character for byte offset.

     - parameter offset: byte offset.
     - parameter tabWidth: the width in spaces to expand tabs to.
     */
    public func lineAndCharacter(forByteOffset offset: Int, expandingTabsToWidth tabWidth: Int = 1) -> (line: Int, character: Int)?

    /**
     Returns a copy of `self` with the trailing contiguous characters belonging to `characterSet`
     removed.

     - parameter characterSet: Character set to check for membership.
     */
    public func trimmingTrailingCharacters(in characterSet: CharacterSet) -> String

    /**
     Returns self represented as an absolute path.

     - parameter rootDirectory: Absolute parent path if not already an absolute path.
     */
    public func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String

    /**
     Converts a range of byte offsets in `self` to an `NSRange` suitable for filtering `self` as an
     `NSString`.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.

     - returns: An equivalent `NSRange`.
     */
    public func byteRangeToNSRange(start: Int, length: Int) -> NSRange?

    /**
     Converts an `NSRange` suitable for filtering `self` as an
     `NSString` to a range of byte offsets in `self`.

     - parameter start: Starting character index in the string.
     - parameter length: Number of characters to include in range.

     - returns: An equivalent `NSRange`.
     */
    public func NSRangeToByteRange(start: Int, length: Int) -> NSRange?

    /**
     Returns a substring with the provided byte range.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.
     */
    public func substringWithByteRange(start: Int, length: Int) -> String?

    /**
     Returns a substring starting at the beginning of `start`'s line and ending at the end of `end`'s
     line. Returns `start`'s entire line if `end` is nil.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.
     */
    public func substringLinesWithByteRange(start: Int, length: Int) -> String?

    public func substringStartingLinesWithByteRange(start: Int, length: Int) -> String?

    /**
     Returns line numbers containing starting and ending byte offsets.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.
     */
    public func lineRangeWithByteRange(start: Int, length: Int) -> (start: Int, end: Int)?

    /**
     Returns an array of Lines for each line in the file.
     */
    public func lines() -> [SourceKittenFramework.Line]

    /**
     Returns true if self is an Objective-C header file.
     */
    public func isObjectiveCHeaderFile() -> Bool

    /**
     Returns true if self is a Swift file.
     */
    public func isSwiftFile() -> Bool

    /**
     Returns a substring from a start and end SourceLocation.
     */
    public func substringWithSourceRange(start: SourceKittenFramework.SourceLocation, end: SourceKittenFramework.SourceLocation) -> String?
}

extension String {
    /// Returns the `#pragma mark`s in the string.
    /// Just the content; no leading dashes or leading `#pragma mark`.
    public func pragmaMarks(filename: String, excludeRanges: [NSRange], limit: NSRange?) -> [SourceKittenFramework.SourceDeclaration]

    /**
     Returns whether or not the `token` can be documented. Either because it is a
     `SyntaxKind.Identifier` or because it is a function treated as a `SyntaxKind.Keyword`:

     - `subscript`
     - `init`
     - `deinit`

     - parameter token: Token to process.
     */
    public func isTokenDocumentable(token: SourceKittenFramework.SyntaxToken) -> Bool

    /**
     Find integer offsets of documented Swift tokens in self.

     - parameter syntaxMap: Syntax Map returned from SourceKit editor.open request.

     - returns: Array of documented token offsets.
     */
    public func documentedTokenOffsets(syntaxMap: SourceKittenFramework.SyntaxMap) -> [Int]

    /**
     Returns the body of the comment if the string is a comment.

     - parameter range: Range to restrict the search for a comment body.
     */
    public func commentBody(range: NSRange? = nil) -> String?

    /// Returns a copy of `self` with the leading whitespace common in each line removed.
    public func removingCommonLeadingWhitespaceFromLines() -> String

    /**
     Returns the number of contiguous characters at the start of `self` belonging to `characterSet`.

     - parameter characterSet: Character set to check for membership.
     */
    public func countOfLeadingCharacters(in characterSet: CharacterSet) -> Int

    /// A version of the string with backslash escapes removed.
    public var unescaped: String { get }
}

extension String: SourceKittenFramework.UIDRepresentable {
    public var uid: SourceKittenFramework.UID { get }
}
