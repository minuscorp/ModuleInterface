/// Constructors are used to translate `Node`s to Swift values.
public final class Constructor {
    /// Maps `Tag.Name`s to `Node.Scalar`s.
    public typealias ScalarMap = [Tag.Name: (Node.Scalar) -> Any?]

    /// Maps `Tag.Name`s to `Node.Mapping`s.
    public typealias MappingMap = [Tag.Name: (Node.Mapping) -> Any?]

    /// Maps `Tag.Name`s to `Node.Sequence`s.
    public typealias SequenceMap = [Tag.Name: (Node.Sequence) -> Any?]

    /// Initialize a `Constructor` with the specified maps, falling back to default maps.
    /// - parameter scalarMap:   Maps `Tag.Name`s to `Node.Scalar`s.
    /// - parameter mappingMap:  Maps `Tag.Name`s to `Node.Mapping`s.
    /// - parameter sequenceMap: Maps `Tag.Name`s to `Node.Sequence`s.
    public init(_ scalarMap: ScalarMap = defaultScalarMap,
                _ mappingMap: MappingMap = defaultMappingMap,
                _ sequenceMap: SequenceMap = defaultSequenceMap)

    /// Constructs Swift values based on the maps this `Constructor` was initialized with.
    /// - parameter node: `Node` from which to extract an `Any` Swift value, if one was produced by the Node
    ///                   type's relevant mapping on this `Constructor`.
    /// - returns: An `Any` Swift value, if one was produced by the Node type's relevant mapping on this
    ///            `Constructor`.
    public func any(from node: Node) -> Any
}

/// Types conforming to this protocol can be extracted `Node.Scalar`s.
public protocol ScalarConstructible {
    /// Construct an instance of `Self`, if possible, from the specified scalar.
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Self`, if possible.
    /// - returns: An instance of `Self`, if one was successfully extracted from the scalar.
    /// - note: We use static constructors to avoid overloading `init?(_ scalar: Node.Scalar)` which would
    ///         cause callsite ambiguities when using `init` as closure.
    static func construct(from scalar: Node.Scalar) -> Self?
}

/// Confirming types are convertible to base 60 numeric values.
public protocol SexagesimalConvertible: ExpressibleByIntegerLiteral {
    /// Creates a sexagesimal numeric value from the given string.
    /// - parameter string: The string from which to parse a sexagesimal value.
    /// - returns: A sexagesimal numeric value, if one was successfully parsed.
    static func create(from string: String) -> Self?

    /// Multiplies two sexagesimal numeric values.
    /// - parameter lhs: Left hand side multiplier.
    /// - parameter rhs: Right hand side multiplier.
    /// - returns: The result of the multiplication.
    static func * (lhs: Self, rhs: Self) -> Self

    /// Adds two sexagesimal numeric values.
    /// - parameter lhs: Left hand side adder.
    /// - parameter rhs: Right hand side adder.
    /// - returns: The result of the addition.
    static func + (lhs: Self, rhs: Self) -> Self
}

/// `Codable`-style `Decoder` that can be used to decode a `Decodable` type from a given `String` and optional
/// user info mapping. Similar to `Foundation.JSONDecoder`.
public class YAMLDecoder {
    /// Creates a `YAMLDecoder` instance.
    /// - parameter encoding: Encoding, `.default` if omitted.
    public init(encoding: Parser.Encoding = .default)

    /// Decode a `Decodable` type from a given `String` and optional user info mapping.
    /// - parameter type:    `Decodable` type to decode.
    /// - parameter yaml:     YAML string to decode.
    /// - parameter userInfo: Additional key/values which can be used when looking up keys to decode.
    /// - returns: Returns the decoded type `T`.
    /// - throws: `DecodingError` if something went wrong while decoding.
    public func decode<T>(_ type: T.Type = T.self,
                          from yaml: String,
                          userInfo: [CodingUserInfoKey: Any] = [:]) throws -> T where T: Swift.Decodable

    /// Encoding
    public var encoding: Parser.Encoding
}

/// Produce a YAML string from objects.
/// - parameter objects:       Sequence of Objects.
/// - parameter canonical:     Output should be the "canonical" format as in the YAML specification.
/// - parameter indent:        The intendation increment.
/// - parameter width:         The preferred line width. @c -1 means unlimited.
/// - parameter allowUnicode:  Unescaped non-ASCII characters are allowed if true.
/// - parameter lineBreak:     Preferred line break.
/// - parameter explicitStart: Explicit document start `---`.
/// - parameter explicitEnd:   Explicit document end `...`.
/// - parameter version:       YAML version directive.
/// - parameter sortKeys:      Whether or not to sort Mapping keys in lexicographic order.
/// - returns: YAML string.
/// - throws: `YamlError`.
public func dump<Objects>(
    objects: Objects,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil,
    sortKeys: Bool = false
) throws -> String
    where Objects: Sequence

/// Produce a YAML string from an object.
/// - parameter object:        Object.
/// - parameter canonical:     Output should be the "canonical" format as in the YAML specification.
/// - parameter indent:        The intendation increment.
/// - parameter width:         The preferred line width. @c -1 means unlimited.
/// - parameter allowUnicode:  Unescaped non-ASCII characters are allowed if true.
/// - parameter lineBreak:     Preferred line break.
/// - parameter explicitStart: Explicit document start `---`.
/// - parameter explicitEnd:   Explicit document end `...`.
/// - parameter version:       YAML version directive.
/// - parameter sortKeys:      Whether or not to sort Mapping keys in lexicographic order.
/// - returns: YAML string.
/// - throws: `YamlError`.
public func dump(
    object: Any?,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil,
    sortKeys: Bool = false
) throws -> String

/// Produce a YAML string from a `Node`.
/// - parameter nodes:         Sequence of `Node`s.
/// - parameter canonical:     Output should be the "canonical" format as in the YAML specification.
/// - parameter indent:        The intendation increment.
/// - parameter width:         The preferred line width. @c -1 means unlimited.
/// - parameter allowUnicode:  Unescaped non-ASCII characters are allowed if true.
/// - parameter lineBreak:     Preferred line break.
/// - parameter explicitStart: Explicit document start `---`.
/// - parameter explicitEnd:   Explicit document end `...`.
/// - parameter version:       YAML version directive.
/// - parameter sortKeys:      Whether or not to sort Mapping keys in lexicographic order.
/// - returns: YAML string.
/// - throws: `YamlError`.
public func serialize<Nodes>(
    nodes: Nodes,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil,
    sortKeys: Bool = false
) throws -> String
    where Nodes: Sequence, Nodes.Iterator.Element == Node

/// Produce a YAML string from a `Node`.
/// - parameter node:          `Node`.
/// - parameter canonical:     Output should be the "canonical" format as in the YAML specification.
/// - parameter indent:        The intendation increment.
/// - parameter width:         The preferred line width. @c -1 means unlimited.
/// - parameter allowUnicode:  Unescaped non-ASCII characters are allowed if true.
/// - parameter lineBreak:     Preferred line break.
/// - parameter explicitStart: Explicit document start `---`.
/// - parameter explicitEnd:   Explicit document end `...`.
/// - parameter version:       YAML version directive.
/// - parameter sortKeys:      Whether or not to sort Mapping keys in lexicographic order.
/// - returns: YAML string.
/// - throws: `YamlError`.
public func serialize(
    node: Node,
    canonical: Bool = false,
    indent: Int = 0,
    width: Int = 0,
    allowUnicode: Bool = false,
    lineBreak: Emitter.LineBreak = .ln,
    explicitStart: Bool = false,
    explicitEnd: Bool = false,
    version: (major: Int, minor: Int)? = nil,
    sortKeys: Bool = false
) throws -> String

/// Class responsible for emitting libYAML events.
public final class Emitter {
    /// Line break options to use when emitting YAML.
    public enum LineBreak {
        /// /// Use CR for line breaks (Mac style).
        case cr
        /// /// Use LN for line breaks (Unix style).
        case ln
        /// /// Use CR LN for line breaks (DOS style).
        case crln
    }

    /// Retrieve this Emitter's binary output.
    public internal(set) var data = Data()

    /// Configuration options to use when emitting YAML.
    public struct Options {
        /// Set if the output should be in the "canonical" format described in the YAML specification.
        public var canonical: Bool = false

        /// Set the indentation value.
        public var indent: Int = 0

        /// Set the preferred line width. -1 means unlimited.
        public var width: Int = 0

        /// Set if unescaped non-ASCII characters are allowed.
        public var allowUnicode: Bool = false

        /// Set the preferred line break.
        public var lineBreak: LineBreak = .ln

        /// The `%YAML` directive value or nil.
        public var version: (major: Int, minor: Int)?

        /// Set if emitter should sort keys in lexicographic order.
        public var sortKeys: Bool = false
    }

    /// Configuration options to use when emitting YAML.
    public var options: Options

    /// Create an `Emitter` with the specified options.
    /// - parameter canonical:     Set if the output should be in the "canonical" format described in the YAML
    ///                            specification.
    /// - parameter indent:        Set the indentation value.
    /// - parameter width:         Set the preferred line width. -1 means unlimited.
    /// - parameter allowUnicode:  Set if unescaped non-ASCII characters are allowed.
    /// - parameter lineBreak:     Set the preferred line break.
    /// - parameter explicitStart: Explicit document start `---`.
    /// - parameter explicitEnd:   Explicit document end `...`.
    /// - parameter version:       The `%YAML` directive value or nil.
    /// - parameter sortKeys:      Set if emitter should sort keys in lexicographic order.
    public init(canonical: Bool = false,
                indent: Int = 0,
                width: Int = 0,
                allowUnicode: Bool = false,
                lineBreak: LineBreak = .ln,
                explicitStart: Bool = false,
                explicitEnd: Bool = false,
                version: (major: Int, minor: Int)? = nil,
                sortKeys: Bool = false)

    deinit

    /// Open & initialize the emmitter.
    /// - throws: `YamlError` if the `Emitter` was already opened or closed.
    public func open() throws

    /// Close the `Emitter.`
    /// - throws: `YamlError` if the `Emitter` hasn't yet been initialized.
    public func close() throws

    /// Ingest a `Node` to include when emitting the YAML output.
    /// - parameter node: The `Node` to serialize.
    /// - throws: `YamlError` if the `Emitter` hasn't yet been opened or has been closed.
    public func serialize(node: Node) throws
}

/// `Codable`-style `Encoder` that can be used to encode an `Encodable` type to a YAML string using optional
/// user info mapping. Similar to `Foundation.JSONEncoder`.
public class YAMLEncoder {
    /// Options to use when encoding to YAML.
    public typealias Options = Emitter.Options

    /// Options to use when encoding to YAML.
    public var options = Options()

    /// Creates a `YAMLEncoder` instance.
    public init()

    /// Encode a value of type `T` to a YAML string.
    /// - parameter value:    Value to encode.
    /// - parameter userInfo: Additional key/values which can be used when looking up keys to encode.
    /// - returns: The YAML string.
    /// - throws: `EncodingError` if something went wrong while encoding.
    public func encode<T: Swift.Encodable>(_ value: T, userInfo: [CodingUserInfoKey: Any] = [:]) throws -> String
}

/// The pointer position.
public struct Mark {
    /// Line number starting from 1.
    public let line: Int

    /// Column number starting from 1. libYAML counts columns in `UnicodeScalar`.
    public let column: Int
}

/// YAML Node.
public enum Node {
    /// /// Scalar node.
    case scalar(Scalar)
    /// /// Mapping node.
    case mapping(Mapping)
    /// /// Sequence node.
    case sequence(Sequence)
}

/// Parse all YAML documents in a String
/// and produce corresponding Swift objects.
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
/// - returns: YamlSequence<Any>
/// - throws: YamlError
public func load_all(yaml: String,
                     _ resolver: Resolver = .default,
                     _ constructor: Constructor = .default,
                     _ encoding: Parser.Encoding = .default) throws -> YamlSequence<Any>

/// Parse the first YAML document in a String
/// and produce the corresponding Swift object.
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
/// - returns: Any?
/// - throws: YamlError
public func load(yaml: String,
                 _ resolver: Resolver = .default,
                 _ constructor: Constructor = .default,
                 _ encoding: Parser.Encoding = .default) throws -> Any?

/// Parse all YAML documents in a String
/// and produce corresponding representation trees.
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
/// - returns: YamlSequence<Node>
/// - throws: YamlError
public func compose_all(yaml: String,
                        _ resolver: Resolver = .default,
                        _ constructor: Constructor = .default,
                        _ encoding: Parser.Encoding = .default) throws -> YamlSequence<Node>

/// Parse the first YAML document in a String
/// and produce the corresponding representation tree.
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
/// - returns: Node?
/// - throws: YamlError
public func compose(yaml: String,
                    _ resolver: Resolver = .default,
                    _ constructor: Constructor = .default,
                    _ encoding: Parser.Encoding = .default) throws -> Node?

/// Sequence that holds an error.
public struct YamlSequence<T>: Sequence, IteratorProtocol {
    /// This sequence's error, if any.
    public private(set) var error: Swift.Error?

    /// `Swift.Sequence.next()`.
    public mutating func next() -> T?
}

/// Parses YAML strings.
public final class Parser {
    /// YAML string.
    public let yaml: String

    /// Resolver.
    public let resolver: Resolver

    /// Constructor.
    public let constructor: Constructor

    /// Encoding
    public enum Encoding: String {
        /// /// Use `YAML_UTF8_ENCODING`
        case utf8
        /// /// Use `YAML_UTF16(BE|LE)_ENCODING`
        case utf16
        /// The default encoding, determined at run time based on the String type's native encoding.
        /// This can be overridden by setting `YAMS_DEFAULT_ENCODING` to either `UTF8` or `UTF16`.
        /// This value is case insensitive.
        public static var `default`: Encoding =
    }

    /// Encoding
    public let encoding: Encoding

    /// Set up Parser.
    /// - parameter string: YAML string.
    /// - parameter resolver: Resolver, `.default` if omitted.
    /// - parameter constructor: Constructor, `.default` if omitted.
    /// - parameter encoding: Encoding, `.default` if omitted.
    /// - throws: `YamlError`.
    public init(yaml string: String,
                resolver: Resolver = .default,
                constructor: Constructor = .default,
                encoding: Encoding = .default) throws

    deinit

    /// Parse next document and return root Node.
    /// - returns: next Node.
    /// - throws: `YamlError`.
    public func nextRoot() throws -> Node?

    /// Parses the document expecting a single root Node and returns it.
    /// - returns: Single root Node.
    /// - throws: `YamlError`.
    public func singleRoot() throws -> Node?
}

public extension Node {
    /// Initialize a `Node` with a value of `NodeRepresentable`.
    /// - parameter representable: Value of `NodeRepresentable` to represent as a `Node`.
    /// - throws: `YamlError`.
    init<T: NodeRepresentable>(_ representable: T) throws
}

/// Type is representable as `Node`.
public protocol NodeRepresentable {
    /// This value's `Node` representation.
    func represented() throws -> Node
}

/// Type is representable as `Node.scalar`.
public protocol ScalarRepresentable: NodeRepresentable {
    /// This value's `Node.scalar` representation.
    func represented() -> Node.Scalar
}

// MARK: - ScalarRepresentableCustomizedForCodable

/// Types conforming to this protocol can be encoded by `YamlEncoder`.
public protocol YAMLEncodable: Encodable {
    /// Returns this value wrapped in a `Node`.
    func box() -> Node
}

/// Class used to resolve nodes to tags based on customizable rules.
public final class Resolver {
    /// Rule describing how to resolve tags from regex patterns.
    public struct Rule {
        /// The tag name this rule applies to.
        public let tag: Tag.Name

        /// The regex pattern used to resolve this rule.
        public var pattern: String

        /// Create a rule with the specified tag name and regex pattern.
        /// - parameter tag: The tag name this rule should apply to.
        /// - parameter pattern: The regex pattern used to resolve this rule.
        /// - throws: Throws an error if the regular expression pattern is invalid.
        public init(_ tag: Tag.Name, _ pattern: String) throws
    }

    /// The rules used by this resolver to resolve nodes to tags.
    public let rules: [Rule]

    /// Resolve a tag name from a given node.
    /// - parameter node: Node whose tag should be resolved.
    /// - returns: The resolved tag name.
    public func resolveTag(of node: Node) -> Tag.Name

    /// Returns a Resolver constructed by appending rule.
    public func appending(_ rule: Rule) -> Resolver

    /// Returns a Resolver constructed by appending pattern for tag.
    public func appending(_ tag: Tag.Name, _ pattern: String) throws -> Resolver

    /// Returns a Resolver constructed by replacing rule.
    public func replacing(_ rule: Rule) -> Resolver

    /// Returns a Resolver constructed by replacing pattern for tag.
    public func replacing(_ tag: Tag.Name, with pattern: String) throws -> Resolver

    /// Returns a Resolver constructed by removing pattern for tag.
    public func removing(_ tag: Tag.Name) -> Resolver
}

/// Tags describe the the _type_ of a Node.
public final class Tag {
    /// Tag name.
    public struct Name: RawRepresentable {
        /// This `Tag.Name`'s raw string value.
        public let rawValue: String

        /// Create a `Tag.Name` with a raw string value.
        public init(rawValue: String)
    }

    /// Shorthand accessor for `Tag(.implicit)`.
    public static var implicit: Tag

    /// Create a `Tag` with the specified name, resolver and constructor.
    /// - parameter name:        Tag name.
    /// - parameter resolver:    `Resolver` this tag should use, `.default` if omitted.
    /// - parameter constructor: `Constructor` this tag should use, `.default` if omitted.
    public init(_ name: Name,
                _ resolver: Resolver = .default,
                _ constructor: Constructor = .default)

    /// Lens returning a copy of the current `Tag` with the specified overridden changes.
    /// - note: Omitting or passing nil for a parameter will preserve the current `Tag`'s value in the copy.
    /// - parameter name:        Overridden tag name.
    /// - parameter resolver:    Overridden resolver.
    /// - parameter constructor: Overridden constructor.
    /// - returns: A copy of the current `Tag` with the specified overridden changes.
    public func copy(with name: Name? = nil, resolver: Resolver? = nil, constructor: Constructor? = nil) -> Tag
}

/// Errors thrown by Yams APIs.
public enum YamlError: Error {
    /// /// `YAML_NO_ERROR`. No error is produced.
    case no
    /// /// `YAML_MEMORY_ERROR`. Cannot allocate or reallocate a block of memory.
    case memory
    /// /// `YAML_READER_ERROR`. Cannot read or decode the input stream.
    /// - parameter problem: Error description.
    /// - parameter offset:  The offset from `yaml.startIndex` at which the problem occured.
    /// - parameter value:   The problematic value (-1 is none).
    /// - parameter yaml:    YAML String which the problem occured while reading.
    case reader(problem: String, offset: Int?, value: Int32, yaml: String)
    /// /// `YAML_SCANNER_ERROR`. Cannot scan the input stream.
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while scanning.
    case scanner(context: Context?, problem: String, Mark, yaml: String)
    /// /// `YAML_PARSER_ERROR`. Cannot parse the input stream.
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while parsing.
    case parser(context: Context?, problem: String, Mark, yaml: String)
    /// /// `YAML_COMPOSER_ERROR`. Cannot compose a YAML document.
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while composing.
    case composer(context: Context?, problem: String, Mark, yaml: String)
    /// /// `YAML_WRITER_ERROR`. Cannot write to the output stream.
    /// - parameter problem: Error description.
    case writer(problem: String)
    /// /// `YAML_EMITTER_ERROR`. Cannot emit a YAML stream.
    /// - parameter problem: Error description.
    case emitter(problem: String)
    /// /// Used in `NodeRepresentable`.
    /// - parameter problem: Error description.
    case representer(problem: String)
    /// The error context.
    public struct Context: CustomStringConvertible {
        /// Context text.
        public let text: String

        /// Context position.
        public let mark: Mark

        /// A textual representation of this instance.
        public var description: String
    }
}
