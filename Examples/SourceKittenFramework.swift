public struct ClangAvailability {
    public let alwaysDeprecated: Bool

    public let alwaysUnavailable: Bool

    public let deprecationMessage: String?

    public let unavailableMessage: String?
}

/// Represents a group of CXTranslationUnits.
public struct ClangTranslationUnit {
    public let declarations: [String: [SourceDeclaration]]

    /// Create a ClangTranslationUnit by passing Objective-C header files and clang compiler arguments.
    /// - parameter headerFiles:       Objective-C header files to document.
    /// - parameter compilerArguments: Clang compiler arguments.
    public init(headerFiles: [String], compilerArguments: [String])

    /// Failable initializer to create a ClangTranslationUnit by passing Objective-C header files and
    /// `xcodebuild` arguments. Optionally pass in a `path`.
    /// - parameter headerFiles:         Objective-C header files to document.
    /// - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to link these header files.
    /// - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    public init?(headerFiles: [String], xcodeBuildArguments: [String], inPath path: String = FileManager.default.currentDirectoryPath)
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

    public let numBytesToErase: NumBytesInt?

    /// Dictionary representation of CodeCompletionItem. Useful for NSJSONSerialization.
    public var dictionaryValue: [String: Any]

    public var description: String

    public static func parse(response: [String: SourceKitRepresentable]) -> [CodeCompletionItem]
}

public extension Dictionary where Key == String, Value == SourceKitRepresentable {
    var referencedUSRs: [String]
}

public struct Documentation {
    public let parameters: [Parameter]

    public let returnDiscussion: [Text]
}

/// Represents a source file.
public final class File {
    /// File path. Nil if initialized directly with `File(contents:)`.
    public let path: String?

    /// File contents.
    public var contents: String

    /// File lines.
    public var lines: [Line]

    /// Failable initializer by path. Fails if file contents could not be read as a UTF8 string.
    /// - parameter path: File path.
    public init?(path: String)

    public init(pathDeferringReading path: String)

    /// Initializer by file contents. File path is nil.
    /// - parameter contents: File contents.
    public init(contents: String)

    /// Formats the file.
    /// - Parameters:
    ///   - trimmingTrailingWhitespace: Boolean
    ///   - useTabs: Boolean
    ///   - indentWidth: Int
    /// - Returns: formatted String
    /// - Throws: Request.Error
    public func format(trimmingTrailingWhitespace: Bool,
                       useTabs: Bool,
                       indentWidth: Int) throws -> String

    /// Parse source declaration string from SourceKit dictionary.
    /// - parameter dictionary: SourceKit dictionary to extract declaration from.
    /// - returns: Source declaration if successfully parsed.
    public func parseDeclaration(_ dictionary: [String: SourceKitRepresentable]) -> String?

    /// Parse line numbers containing the declaration's implementation from SourceKit dictionary.
    /// - parameter dictionary: SourceKit dictionary to extract declaration from.
    /// - returns: Line numbers containing the declaration's implementation.
    public func parseScopeRange(_ dictionary: [String: SourceKitRepresentable]) -> (start: Int, end: Int)?

    /// Returns a copy of the input dictionary with comment mark names, cursor.info information and
    /// parsed declarations for the top-level of the input dictionary and its substructures.
    /// - parameter dictionary:        Dictionary to process.
    /// - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
    public func process(dictionary: [String: SourceKitRepresentable], cursorInfoRequest: SourceKitObject? = nil,
                        syntaxMap: SyntaxMap? = nil) -> [String: SourceKitRepresentable]
}

/// Parse XML from `key.doc.full_as_xml` from `cursor.info` request.
/// - parameter xmlDocs: Contents of `key.doc.full_as_xml` from SourceKit.
/// - returns: XML parsed as an `[String: SourceKitRepresentable]`.
public func parseFullXMLDocs(_ xmlDocs: String) -> [String: SourceKitRepresentable]?

/// JSON Object to JSON String.
/// - parameter object: Object to convert to JSON.
/// - returns: JSON string representation of the input object.
public func toJSON(_ object: Any) -> String

/// Convert [String: SourceKitRepresentable] to `NSDictionary`.
/// - parameter dictionary: [String: SourceKitRepresentable] to convert.
/// - returns: JSON-serializable value.
public func toNSDictionary(_ dictionary: [String: SourceKitRepresentable]) -> NSDictionary

public func declarationsToJSON(_ decl: [String: [SourceDeclaration]]) -> String

/// Language Enum.
public enum Language {
    /// Swift.
    case swift
    /// Objective-C.
    case objc
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
    public var docs: [SwiftDocs]

    public init?(spmName: String, inPath path: String = FileManager.default.currentDirectoryPath)

    /// Failable initializer to create a Module by the arguments necessary pass in to `xcodebuild` to build it.
    /// Optionally pass in a `moduleName` and `path`.
    /// - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this Module.
    /// - parameter name:                Module name. Will be parsed from `xcodebuild` output if nil.
    /// - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    public init?(xcodeBuildArguments: [String], name: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath)

    /// Initializer to create a Module by name and compiler arguments.
    /// - parameter name:              Module name.
    /// - parameter compilerArguments: Compiler arguments required by SourceKit to process the source files in this Module.
    public init(name: String, compilerArguments: [String])
}

/// Objective-C declaration kinds.
/// More or less equivalent to `SwiftDeclarationKind`, but with made up values because there's no such
/// thing as SourceKit for Objective-C.
public enum ObjCDeclarationKind: String {
    /// `category`.
    case category = "sourcekitten.source.lang.objc.decl.category"
    /// `class`.
    case `class` = "sourcekitten.source.lang.objc.decl.class"
    /// `constant`.
    case constant = "sourcekitten.source.lang.objc.decl.constant"
    /// `enum`.
    case `enum` = "sourcekitten.source.lang.objc.decl.enum"
    /// `enumcase`.
    case enumcase = "sourcekitten.source.lang.objc.decl.enumcase"
    /// `initializer`.
    case initializer = "sourcekitten.source.lang.objc.decl.initializer"
    /// `method.class`.
    case methodClass = "sourcekitten.source.lang.objc.decl.method.class"
    /// `method.instance`.
    case methodInstance = "sourcekitten.source.lang.objc.decl.method.instance"
    /// `property`.
    case property = "sourcekitten.source.lang.objc.decl.property"
    /// `protocol`.
    case `protocol` = "sourcekitten.source.lang.objc.decl.protocol"
    /// `typedef`.
    case typedef = "sourcekitten.source.lang.objc.decl.typedef"
    /// `function`.
    case function = "sourcekitten.source.lang.objc.decl.function"
    /// `mark`.
    case mark = "sourcekitten.source.lang.objc.mark"
    /// `struct`
    case `struct` = "sourcekitten.source.lang.objc.decl.struct"
    /// `field`
    case field = "sourcekitten.source.lang.objc.decl.field"
    /// `ivar`
    case ivar = "sourcekitten.source.lang.objc.decl.ivar"
    /// `ModuleImport`
    case moduleImport = "sourcekitten.source.lang.objc.module.import"
    /// `UnexposedDecl`
    case unexposedDecl = "sourcekitten.source.lang.objc.decl.unexposed"
    public init(_ cursorKind: CXCursorKind)
}

/// Type that maps potentially documented declaration offsets to its closest parent offset.
public typealias OffsetMap = [Int: Int]

public struct Parameter {
    public let name: String

    public let discussion: [Text]
}

public protocol SourceKitRepresentable {
    func isEqualTo(_ rhs: SourceKitRepresentable) -> Bool
}

/// Represents a SourceKit request.
public enum Request {
    /// An `editor.open` request for the given File.
    case editorOpen(file: File)
    /// A `cursorinfo` request for an offset in the given file, using the `arguments` given.
    case cursorInfo(file: String, offset: Int64, arguments: [String])
    /// A `cursorinfo` request for a USR in the given file, using the `arguments` given.
    case cursorInfoUSR(file: String, usr: String, arguments: [String], cancelOnSubsequentRequest: Bool)
    /// A custom request by passing in the `SourceKitObject` directly.
    case customRequest(request: SourceKitObject)
    /// A request generated by sourcekit using the yaml representation.
    case yamlRequest(yaml: String)
    /// A `codecomplete` request by passing in the file name, contents, offset
    for which to generate code completion options and array of compiler arguments.
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
    binary data otherwise.
        case syntaxTree(file: File, byteTree: Bool)
    /// Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].
    /// - returns: SourceKit output as a dictionary.
    /// - throws: Request.Error on fail ()
    public func send() throws -> [String: SourceKitRepresentable]

    /// A enum representation of SOURCEKITD_ERROR_*
    public enum Error: Swift.Error, CustomStringConvertible {
        /// A textual representation of `self`.
        public var description: String
    }

    /// Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].
    /// - returns: SourceKit output as a dictionary.
    /// - throws: Request.Error on fail ()
    public func failableSend() throws -> [String: SourceKitRepresentable]
}

public func insertMarks(declarations: [SourceDeclaration], limit: NSRange? = nil) -> [SourceDeclaration]

/// Represents a source code declaration.
public struct SourceDeclaration {
    public let type: ObjCDeclarationKind

    public let location: SourceLocation

    public let extent: (start: SourceLocation, end: SourceLocation)

    public let name: String?

    public let usr: String?

    public let declaration: String?

    public let documentation: Documentation?

    public let commentBody: String?

    public var children: [SourceDeclaration]

    public let annotations: [String]?

    public let swiftDeclaration: String?

    public let swiftName: String?

    public let availability: ClangAvailability?

    /// Range
    public var range: NSRange

    /// Returns the USR for the auto-generated getter for this property.
    /// - warning: can only be invoked if `type == .Property`.
    public var getterUSR: String

    /// Returns the USR for the auto-generated setter for this property.
    /// - warning: can only be invoked if `type == .Property`.
    public var setterUSR: String
}

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func < (lhs: SourceDeclaration, rhs: SourceDeclaration) -> Bool

public protocol SourceKitObjectConvertible {
    var sourceKitObject: SourceKitObject?
}

/// Swift representation of sourcekitd_object_t
public final class SourceKitObject {
    deinit

    /// Updates the value stored in the dictionary for the given key,
    /// or adds a new key-value pair if the key does not exist.
    /// - Parameters:
    ///   - value: The new value to add to the dictionary.
    ///   - key: The key to associate with value. If key already exists in the dictionary,
    ///     value replaces the existing associated value. If key isn't already a key of the dictionary
    public func updateValue(_ value: SourceKitObjectConvertible, forKey key: UID)

    public func updateValue(_ value: SourceKitObjectConvertible, forKey key: String)

    public func updateValue<T>(_ value: SourceKitObjectConvertible, forKey key: T) where T: RawRepresentable, T.RawValue == String
}

public struct SourceLocation {
    public let file: String

    public let line: UInt32

    public let column: UInt32

    public let offset: UInt32

    public func range(toEnd end: SourceLocation) -> NSRange
}

public func == (lhs: SourceLocation, rhs: SourceLocation) -> Bool

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func < (lhs: SourceLocation, rhs: SourceLocation) -> Bool

/// Swift declaration kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.stmt.`.
public enum StatementKind: String {
    /// `brace`.
    case brace = "source.lang.swift.stmt.brace"
    /// `case`.
    case `case` = "source.lang.swift.stmt.case"
    /// `for`.
    case `for` = "source.lang.swift.stmt.for"
    /// `foreach`.
    case forEach = "source.lang.swift.stmt.foreach"
    /// `guard`.
    case `guard` = "source.lang.swift.stmt.guard"
    /// `if`.
    case `if` = "source.lang.swift.stmt.if"
    /// `repeatewhile`.
    case repeatWhile = "source.lang.swift.stmt.repeatwhile"
    /// `switch`.
    case `switch` = "source.lang.swift.stmt.switch"
    /// `while`.
    case `while` = "source.lang.swift.stmt.while"
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

/// Represents the structural information in a Swift source file.
public struct Structure {
    /// Structural information as an [String: SourceKitRepresentable].
    public let dictionary: [String: SourceKitRepresentable]

    /// Create a Structure from a SourceKit `editor.open` response.
    ///
    /// - parameter sourceKitResponse: SourceKit `editor.open` response.
    public init(sourceKitResponse: [String: SourceKitRepresentable])

    /// Initialize a Structure by passing in a File.
    /// - parameter file: File to parse for structural information.
    /// - throws: Request.Error
    public init(file: File) throws
}

/// Returns true if `lhs` Structure is equal to `rhs` Structure.
/// - parameter lhs: Structure to compare to `rhs`.
/// - parameter rhs: Structure to compare to `lhs`.
/// - returns: True if `lhs` Structure is equal to `rhs` Structure.
public func == (lhs: Structure, rhs: Structure) -> Bool

/// Swift declaration attribute kinds.
/// Found in `strings SourceKitService | grep source.decl.attribute.`.
public enum SwiftDeclarationAttributeKind: String, CaseIterable {}

/// Swift declaration kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.decl.`.
public enum SwiftDeclarationKind: String, CaseIterable {
    /// `associatedtype`.
    case `associatedtype` = "source.lang.swift.decl.associatedtype"
    /// `class`.
    case `class` = "source.lang.swift.decl.class"
    /// `enum`.
    case `enum` = "source.lang.swift.decl.enum"
    /// `enumcase`.
    case enumcase = "source.lang.swift.decl.enumcase"
    /// `enumelement`.
    case enumelement = "source.lang.swift.decl.enumelement"
    /// `extension`.
    case `extension` = "source.lang.swift.decl.extension"
    /// `extension.class`.
    case extensionClass = "source.lang.swift.decl.extension.class"
    /// `extension.enum`.
    case extensionEnum = "source.lang.swift.decl.extension.enum"
    /// `extension.protocol`.
    case extensionProtocol = "source.lang.swift.decl.extension.protocol"
    /// `extension.struct`.
    case extensionStruct = "source.lang.swift.decl.extension.struct"
    /// `function.accessor.address`.
    case functionAccessorAddress = "source.lang.swift.decl.function.accessor.address"
    /// `function.accessor.didset`.
    case functionAccessorDidset = "source.lang.swift.decl.function.accessor.didset"
    /// `function.accessor.getter`.
    case functionAccessorGetter = "source.lang.swift.decl.function.accessor.getter"
    /// `function.accessor.modify`
    case functionAccessorModify = "source.lang.swift.decl.function.accessor.modify"
    /// `function.accessor.mutableaddress`.
    case functionAccessorMutableaddress = "source.lang.swift.decl.function.accessor.mutableaddress"
    /// `function.accessor.read`
    case functionAccessorRead = "source.lang.swift.decl.function.accessor.read"
    /// `function.accessor.setter`.
    case functionAccessorSetter = "source.lang.swift.decl.function.accessor.setter"
    /// `function.accessor.willset`.
    case functionAccessorWillset = "source.lang.swift.decl.function.accessor.willset"
    /// `function.constructor`.
    case functionConstructor = "source.lang.swift.decl.function.constructor"
    /// `function.destructor`.
    case functionDestructor = "source.lang.swift.decl.function.destructor"
    /// `function.free`.
    case functionFree = "source.lang.swift.decl.function.free"
    /// `function.method.class`.
    case functionMethodClass = "source.lang.swift.decl.function.method.class"
    /// `function.method.instance`.
    case functionMethodInstance = "source.lang.swift.decl.function.method.instance"
    /// `function.method.static`.
    case functionMethodStatic = "source.lang.swift.decl.function.method.static"
    /// `function.operator`.
    case functionOperator = "source.lang.swift.decl.function.operator"
    /// `function.operator.infix`.
    case functionOperatorInfix = "source.lang.swift.decl.function.operator.infix"
    /// `function.operator.postfix`.
    case functionOperatorPostfix = "source.lang.swift.decl.function.operator.postfix"
    /// `function.operator.prefix`.
    case functionOperatorPrefix = "source.lang.swift.decl.function.operator.prefix"
    /// `function.subscript`.
    case functionSubscript = "source.lang.swift.decl.function.subscript"
    /// `generic_type_param`.
    case genericTypeParam = "source.lang.swift.decl.generic_type_param"
    /// `module`.
    case module = "source.lang.swift.decl.module"
    /// `precedencegroup`.
    case precedenceGroup = "source.lang.swift.decl.precedencegroup"
    /// `protocol`.
    case `protocol` = "source.lang.swift.decl.protocol"
    /// `struct`.
    case `struct` = "source.lang.swift.decl.struct"
    /// `typealias`.
    case `typealias` = "source.lang.swift.decl.typealias"
    /// `var.class`.
    case varClass = "source.lang.swift.decl.var.class"
    /// `var.global`.
    case varGlobal = "source.lang.swift.decl.var.global"
    /// `var.instance`.
    case varInstance = "source.lang.swift.decl.var.instance"
    /// `var.local`.
    case varLocal = "source.lang.swift.decl.var.local"
    /// `var.parameter`.
    case varParameter = "source.lang.swift.decl.var.parameter"
    /// `var.static`.
    case varStatic = "source.lang.swift.decl.var.static"
}

/// SourceKit response dictionary keys.
public enum SwiftDocKey: String {
    /// Annotated declaration (String).
    case annotatedDeclaration = "key.annotated_decl"
    /// Body length (Int64).
    case bodyLength = "key.bodylength"
    /// Body offset (Int64).
    case bodyOffset = "key.bodyoffset"
    /// Diagnostic stage (String).
    case diagnosticStage = "key.diagnostic_stage"
    /// Elements ([[String: SourceKitRepresentable]]).
    case elements = "key.elements"
    /// File path (String).
    case filePath = "key.filepath"
    /// Full XML docs (String).
    case fullXMLDocs = "key.doc.full_as_xml"
    /// Kind (String).
    case kind = "key.kind"
    /// Length (Int64).
    case length = "key.length"
    /// Name (String).
    case name = "key.name"
    /// Name length (Int64).
    case nameLength = "key.namelength"
    /// Name offset (Int64).
    case nameOffset = "key.nameoffset"
    /// Offset (Int64).
    case offset = "key.offset"
    /// Substructure ([[String: SourceKitRepresentable]]).
    case substructure = "key.substructure"
    /// Syntax map (NSData).
    case syntaxMap = "key.syntaxmap"
    /// Type name (String).
    case typeName = "key.typename"
    /// Inheritedtype ([SourceKitRepresentable])
    case inheritedtypes = "key.inheritedtypes"
    /// Column where the token's declaration begins (Int64).
    case docColumn = "key.doc.column"
    /// Documentation comment (String).
    case documentationComment = "key.doc.comment"
    /// Declaration of documented token (String).
    case docDeclaration = "key.doc.declaration"
    /// Discussion documentation of documented token ([SourceKitRepresentable]).
    case docDiscussion = "key.doc.discussion"
    /// File where the documented token is located (String).
    case docFile = "key.doc.file"
    /// Line where the token's declaration begins (Int64).
    case docLine = "key.doc.line"
    /// Name of documented token (String).
    case docName = "key.doc.name"
    /// Parameters of documented token ([SourceKitRepresentable]).
    case docParameters = "key.doc.parameters"
    /// Parsed declaration (String).
    case docResultDiscussion = "key.doc.result_discussion"
    /// Parsed scope start (Int64).
    case docType = "key.doc.type"
    /// Parsed scope start end (Int64).
    case usr = "key.usr"
    /// Result discussion documentation of documented token ([SourceKitRepresentable]).
    case parsedDeclaration = "key.parsed_declaration"
    /// Type of documented token (String).
    case parsedScopeEnd = "key.parsed_scope.end"
    /// USR of documented token (String).
    case parsedScopeStart = "key.parsed_scope.start"
    /// Swift Declaration (String).
    case swiftDeclaration = "key.swift_declaration"
    /// Swift Name (String).
    case swiftName = "key.swift_name"
    /// Always deprecated (Bool).
    case alwaysDeprecated = "key.always_deprecated"
    /// Always unavailable (Bool).
    case alwaysUnavailable = "key.always_unavailable"
    /// Always deprecated (String).
    case deprecationMessage = "key.deprecation_message"
    /// Always unavailable (String).
    case unavailableMessage = "key.unavailable_message"
    /// Annotations ([String]).
    case annotations = "key.annotations"
}

/// Represents docs for a Swift file.
public struct SwiftDocs {
    /// Documented File.
    public let file: File

    /// Docs information as an [String: SourceKitRepresentable].
    public let docsDictionary: [String: SourceKitRepresentable]

    /// Create docs for the specified Swift file and compiler arguments.
    /// - parameter file:      Swift file to document.
    /// - parameter arguments: compiler arguments to pass to SourceKit.
    public init?(file: File, arguments: [String])

    /// Create docs for the specified Swift file, editor.open SourceKit response and cursor info request.
    /// - parameter file:              Swift file to document.
    /// - parameter dictionary:        editor.open response from SourceKit.
    /// - parameter cursorInfoRequest: SourceKit dictionary to use to send cursorinfo request.
    public init(file: File, dictionary: [String: SourceKitRepresentable], cursorInfoRequest: SourceKitObject?)
}

/// Syntax kind values.
/// Found in `strings SourceKitService | grep source.lang.swift.syntaxtype.`.
public enum SyntaxKind: String {
    /// `argument`.
    case argument = "source.lang.swift.syntaxtype.argument"
    /// `attribute.builtin`.
    case attributeBuiltin = "source.lang.swift.syntaxtype.attribute.builtin"
    /// `attribute.id`.
    case attributeID = "source.lang.swift.syntaxtype.attribute.id"
    /// `buildconfig.id`.
    case buildconfigID = "source.lang.swift.syntaxtype.buildconfig.id"
    /// `buildconfig.keyword`.
    case buildconfigKeyword = "source.lang.swift.syntaxtype.buildconfig.keyword"
    /// `comment`.
    case comment = "source.lang.swift.syntaxtype.comment"
    /// `comment.mark`.
    case commentMark = "source.lang.swift.syntaxtype.comment.mark"
    /// `comment.url`.
    case commentURL = "source.lang.swift.syntaxtype.comment.url"
    /// `doccomment`.
    case docComment = "source.lang.swift.syntaxtype.doccomment"
    /// `doccomment.field`.
    case docCommentField = "source.lang.swift.syntaxtype.doccomment.field"
    /// `identifier`.
    case identifier = "source.lang.swift.syntaxtype.identifier"
    /// `keyword`.
    case keyword = "source.lang.swift.syntaxtype.keyword"
    /// `number`.
    case number = "source.lang.swift.syntaxtype.number"
    /// `objectliteral`
    case objectLiteral = "source.lang.swift.syntaxtype.objectliteral"
    /// `parameter`.
    case parameter = "source.lang.swift.syntaxtype.parameter"
    /// `placeholder`.
    case placeholder = "source.lang.swift.syntaxtype.placeholder"
    /// `string`.
    case string = "source.lang.swift.syntaxtype.string"
    /// `string_interpolation_anchor`.
    case stringInterpolationAnchor = "source.lang.swift.syntaxtype.string_interpolation_anchor"
    /// `typeidentifier`.
    case typeidentifier = "source.lang.swift.syntaxtype.typeidentifier"
    /// `pounddirective.keyword`.
    case poundDirectiveKeyword = "source.lang.swift.syntaxtype.pounddirective.keyword"
}

/// Represents a Swift file's syntax information.
public struct SyntaxMap {
    /// Array of SyntaxToken's.
    public let tokens: [SyntaxToken]

    /// Create a SyntaxMap by passing in tokens directly.
    /// - parameter tokens: Array of SyntaxToken's.
    public init(tokens: [SyntaxToken])

    /// Create a SyntaxMap by passing in NSData from a SourceKit `editor.open` response to be parsed.
    /// - parameter data: NSData from a SourceKit `editor.open` response
    public init(data: [SourceKitRepresentable])

    /// Create a SyntaxMap from a SourceKit `editor.open` response.
    /// - parameter sourceKitResponse: SourceKit `editor.open` response.
    public init(sourceKitResponse: [String: SourceKitRepresentable])

    /// Create a SyntaxMap from a File to be parsed.
    /// - parameter file: File to be parsed.
    /// - throws: Request.Error
    public init(file: File) throws
}

/// Returns true if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.
/// - parameter lhs: SyntaxMap to compare to `rhs`.
/// - parameter rhs: SyntaxMap to compare to `lhs`.
/// - returns: True if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.
public func == (lhs: SyntaxMap, rhs: SyntaxMap) -> Bool

/// Represents a single Swift syntax token.
public struct SyntaxToken {
    /// Token type. See SyntaxKind.
    public let type: String

    /// Token offset.
    public let offset: Int

    /// Token length.
    public let length: Int

    /// Dictionary representation of SyntaxToken. Useful for NSJSONSerialization.
    public var dictionaryValue: [String: Any]

    /// Create a SyntaxToken by directly passing in its property values.
    /// - parameter type:   Token type. See SyntaxKind.
    /// - parameter offset: Token offset.
    /// - parameter length: Token length.
    public init(type: String, offset: Int, length: Int)
}

/// Returns true if `lhs` SyntaxToken is equal to `rhs` SyntaxToken.
/// - parameter lhs: SyntaxToken to compare to `rhs`.
/// - parameter rhs: SyntaxToken to compare to `lhs`.
/// - returns: True if `lhs` SyntaxToken is equal to `rhs` SyntaxToken.
public func == (lhs: SyntaxToken, rhs: SyntaxToken) -> Bool

public enum Text {}

/// Swift representation of sourcekitd_uid_t
public struct UID: Hashable {
    public init(_ string: String)

    public init<T>(_ rawRepresentable: T) where T: RawRepresentable, T.RawValue == String
}

public protocol UIDRepresentable {
    var uid: UID
}

public struct Version {
    public let value: String

    public static let current = Version(value: "0.24.0")
}

/// Extracts Objective-C header files and `xcodebuild` arguments from an array of header files followed by `xcodebuild` arguments.
/// - parameter sourcekittenArguments: Array of Objective-C header files followed by `xcodebuild` arguments.
/// - returns: Tuple of header files and xcodebuild arguments.
public func parseHeaderFilesAndXcodebuildArguments(sourcekittenArguments: [String]) -> (headerFiles: [String], xcodebuildArguments: [String])

public func sdkPath() -> String
