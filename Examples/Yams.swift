import CYaml
import Foundation
import SwiftOnoneSupport

/// Constructors are used to translate `Node`s to Swift values.
public final class Constructor {
    /// Maps `Tag.Name`s to `Node.Scalar`s.
    public typealias ScalarMap = [Yams.Tag.Name: (Yams.Node.Scalar) -> Any?]

    /// Maps `Tag.Name`s to `Node.Mapping`s.
    public typealias MappingMap = [Yams.Tag.Name: (Yams.Node.Mapping) -> Any?]

    /// Maps `Tag.Name`s to `Node.Sequence`s.
    public typealias SequenceMap = [Yams.Tag.Name: (Yams.Node.Sequence) -> Any?]

    /// Initialize a `Constructor` with the specified maps, falling back to default maps.
    ///
    /// - parameter scalarMap:   Maps `Tag.Name`s to `Node.Scalar`s.
    /// - parameter mappingMap:  Maps `Tag.Name`s to `Node.Mapping`s.
    /// - parameter sequenceMap: Maps `Tag.Name`s to `Node.Sequence`s.
    public init(_ scalarMap: Yams.Constructor.ScalarMap = defaultScalarMap, _ mappingMap: Yams.Constructor.MappingMap = defaultMappingMap, _ sequenceMap: Yams.Constructor.SequenceMap = defaultSequenceMap)

    /// Constructs Swift values based on the maps this `Constructor` was initialized with.
    ///
    /// - parameter node: `Node` from which to extract an `Any` Swift value, if one was produced by the Node
    ///                   type's relevant mapping on this `Constructor`.
    ///
    /// - returns: An `Any` Swift value, if one was produced by the Node type's relevant mapping on this
    ///            `Constructor`.
    public func any(from node: Yams.Node) -> Any
}

extension Constructor {
    /// The default `Constructor` to be used with APIs where none is explicitly provided.
    public static let `default`: Yams.Constructor

    /// The default `Tag.Name` to `Node.Scalar` map.
    public static let defaultScalarMap: Yams.Constructor.ScalarMap

    /// The default `Tag.Name` to `Node.Mapping` map.
    public static let defaultMappingMap: Yams.Constructor.MappingMap

    /// The default `Tag.Name` to `Node.Sequence` map.
    public static let defaultSequenceMap: Yams.Constructor.SequenceMap
}

/// Class responsible for emitting libYAML events.
public final class Emitter {
    /// Line break options to use when emitting YAML.
    public enum LineBreak {
        /// Use CR for line breaks (Mac style).
        case cr

        /// Use LN for line breaks (Unix style).
        case ln

        /// Use CR LN for line breaks (DOS style).
        case crln
    }

    /// Retrieve this Emitter's binary output.
    public internal(set) var data: Data {
        get
    }

    /// Configuration options to use when emitting YAML.
    public struct Options {
        /// Set if the output should be in the "canonical" format described in the YAML specification.
        public var canonical: Bool

        /// Set the indentation value.
        public var indent: Int

        /// Set the preferred line width. -1 means unlimited.
        public var width: Int

        /// Set if unescaped non-ASCII characters are allowed.
        public var allowUnicode: Bool

        /// Set the preferred line break.
        public var lineBreak: Yams.Emitter.LineBreak

        /// The `%YAML` directive value or nil.
        public var version: (major: Int, minor: Int)?

        /// Set if emitter should sort keys in lexicographic order.
        public var sortKeys: Bool
    }

    /// Configuration options to use when emitting YAML.
    public var options: Yams.Emitter.Options

    /// Create an `Emitter` with the specified options.
    ///
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
    public init(canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, explicitStart: Bool = false, explicitEnd: Bool = false, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false)

    /// Open & initialize the emmitter.
    ///
    /// - throws: `YamlError` if the `Emitter` was already opened or closed.
    public func open() throws

    /// Close the `Emitter.`
    ///
    /// - throws: `YamlError` if the `Emitter` hasn't yet been initialized.
    public func close() throws

    /// Ingest a `Node` to include when emitting the YAML output.
    ///
    /// - parameter node: The `Node` to serialize.
    ///
    /// - throws: `YamlError` if the `Emitter` hasn't yet been opened or has been closed.
    public func serialize(node: Yams.Node) throws
}

extension Emitter.Options {
    /// Create `Emitter.Options` with the specified values.
    ///
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
    public init(canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false)
}

/// The pointer position.
public struct Mark {
    /// Line number starting from 1.
    public let line: Int

    /// Column number starting from 1. libYAML counts columns in `UnicodeScalar`.
    public let column: Int
}

extension Mark: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String { get }
}

extension Mark {
    /// Returns snippet string pointed by Mark instance from YAML String.
    public func snippet(from yaml: String) -> String
}

/// YAML Node.
public enum Node {
    /// Scalar node.
    case scalar(Yams.Node.Scalar)

    /// Mapping node.
    case mapping(Yams.Node.Mapping)

    /// Sequence node.
    case sequence(Yams.Node.Sequence)
}

extension Node {
    /// A mapping is the YAML equivalent of a `Dictionary`.
    public struct Mapping {
        /// This mapping's `Tag`.
        public var tag: Yams.Tag

        /// The style to use when emitting this `Mapping`.
        public var style: Yams.Node.Mapping.Style

        /// This mapping's `Mark`.
        public var mark: Yams.Mark?

        /// The style to use when emitting a `Mapping`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any

            /// The block mapping style.
            case block

            /// The flow mapping style.
            case flow
        }

        /// Create a `Node.Mapping` using the specified parameters.
        ///
        /// - parameter pairs: The array of `(Node, Node)` tuples to generate this mapping.
        /// - parameter tag:   This mapping's `Tag`.
        /// - parameter style: The style to use when emitting this `Mapping`.
        /// - parameter mark:  This mapping's `Mark`.
        public init(_ pairs: [(Yams.Node, Yams.Node)], _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Mapping.Style = .any, _ mark: Yams.Mark? = nil)
    }

    /// Get or set the `Node.Mapping` value if this node is a `Node.mapping`.
    public var mapping: Yams.Node.Mapping?
}

extension Node {
    /// Scalar node.
    public struct Scalar {
        /// This node's string value.
        public var string: String

        /// This node's tag (its type).
        public var tag: Yams.Tag

        /// The style to be used when emitting this node.
        public var style: Yams.Node.Scalar.Style

        /// The location for this node.
        public var mark: Yams.Mark?

        /// The style to use when emitting a `Scalar`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any

            /// The plain scalar style.
            case plain

            /// The single-quoted scalar style.
            case singleQuoted

            /// The double-quoted scalar style.
            case doubleQuoted

            /// The literal scalar style.
            case literal

            /// The folded scalar style.
            case folded
        }

        /// Create a `Node.Scalar` using the specified parameters.
        ///
        /// - parameter string: The string to generate this scalar.
        /// - parameter tag:    This scalar's `Tag`.
        /// - parameter style:  The style to use when emitting this `Scalar`.
        /// - parameter mark:   This scalar's `Mark`.
        public init(_ string: String, _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Scalar.Style = .any, _ mark: Yams.Mark? = nil)
    }

    /// Get or set the `Node.Scalar` value if this node is a `Node.scalar`.
    public var scalar: Yams.Node.Scalar?
}

extension Node {
    /// Sequence node.
    public struct Sequence {
        /// This node's tag (its type).
        public var tag: Yams.Tag

        /// The style to be used when emitting this node.
        public var style: Yams.Node.Sequence.Style

        /// The location for this node.
        public var mark: Yams.Mark?

        /// The style to use when emitting a `Sequence`.
        public enum Style: UInt32 {
            /// Let the emitter choose the style.
            case any

            /// The block sequence style.
            case block

            /// The flow sequence style.
            case flow
        }

        /// Create a `Node.Sequence` using the specified parameters.
        ///
        /// - parameter nodes: The array of nodes to generate this sequence.
        /// - parameter tag:   This sequence's `Tag`.
        /// - parameter style: The style to use when emitting this `Sequence`.
        /// - parameter mark:  This sequence's `Mark`.
        public init(_ nodes: [Yams.Node], _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Sequence.Style = .any, _ mark: Yams.Mark? = nil)
    }

    /// Get or set the `Node.Sequence` value if this node is a `Node.sequence`.
    public var sequence: Yams.Node.Sequence?
}

extension Node {
    /// Create a `Node.scalar` with a string, tag & scalar style.
    ///
    /// - parameter string: String value for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ string: String, _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Scalar.Style = .any)

    /// Create a `Node.mapping` with a sequence of node pairs, tag & scalar style.
    ///
    /// - parameter pairs:  Pairs of nodes to use for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ pairs: [(Yams.Node, Yams.Node)], _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Mapping.Style = .any)

    /// Create a `Node.sequence` with a sequence of nodes, tag & scalar style.
    ///
    /// - parameter nodes:  Sequence of nodes to use for this node.
    /// - parameter tag:    Tag for this node.
    /// - parameter style:  Style to use when emitting this node.
    public init(_ nodes: [Yams.Node], _ tag: Yams.Tag = .implicit, _ style: Yams.Node.Sequence.Style = .any)
}

extension Node {
    /// The tag for this node.
    ///
    /// - note: Accessing this property causes the tag to be resolved by tag.resolver.
    public var tag: Yams.Tag { get }

    /// The location for this node.
    public var mark: Yams.Mark? { get }

    /// This node as an `Any`, if convertible.
    public var any: Any { get }

    /// This node as a `String`, if convertible.
    public var string: String? { get }

    /// This node as a `Bool`, if convertible.
    public var bool: Bool? { get }

    /// This node as a `Double`, if convertible.
    public var float: Double? { get }

    /// This node as an `NSNull`, if convertible.
    public var null: NSNull? { get }

    /// This node as an `Int`, if convertible.
    public var int: Int? { get }

    /// This node as a `Data`, if convertible.
    public var binary: Data? { get }

    /// This node as a `Date`, if convertible.
    public var timestamp: Date? { get }

    /// Returns this node mapped as an `Array<Node>`. If the node isn't a `Node.sequence`, the array will be
    /// empty.
    public func array() -> [Yams.Node]

    /// Typed Array using type parameter: e.g. `array(of: String.self)`.
    ///
    /// - parameter type: Type conforming to `ScalarConstructible`.
    ///
    /// - returns: Array of `Type`.
    public func array<Type>(of type: Type.Type = Type.self) -> [Type] where Type: Yams.ScalarConstructible

    /// If the node is a `.sequence` or `.mapping`, set or get the specified `Node`.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(node: Yams.Node) -> Yams.Node?

    /// If the node is a `.sequence` or `.mapping`, set or get the specified parameter's `Node`
    /// representation.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(representable: Yams.NodeRepresentable) -> Yams.Node?

    /// If the node is a `.sequence` or `.mapping`, set or get the specified string's `Node` representation.
    /// If the node is a `.scalar`, this is a no-op.
    public subscript(string: String) -> Yams.Node?
}

extension Node: Hashable {}

extension Node: Comparable {
    /// Returns true if `lhs` is ordered before `rhs`.
    ///
    /// - parameter lhs: The left hand side Node to compare.
    /// - parameter rhs: The right hand side Node to compare.
    ///
    /// - returns: True if `lhs` is ordered before `rhs`.
    public static func < (lhs: Yams.Node, rhs: Yams.Node) -> Bool
}

extension Node: ExpressibleByArrayLiteral {
    /// Create a `Node.sequence` from an array literal of `Node`s.
    public init(arrayLiteral elements: Yams.Node...)
}

extension Node: ExpressibleByDictionaryLiteral {
    /// Create a `Node.mapping` from a dictionary literal of `Node`s.
    public init(dictionaryLiteral elements: (Yams.Node, Yams.Node)...)
}

extension Node: ExpressibleByFloatLiteral {
    /// Create a `Node.scalar` from a float literal.
    public init(floatLiteral value: Double)
}

extension Node: ExpressibleByIntegerLiteral {
    /// Create a `Node.scalar` from an integer literal.
    public init(integerLiteral value: Int)
}

extension Node: ExpressibleByStringLiteral {
    /// Create a `Node.scalar` from a string literal.
    public init(stringLiteral value: String)
}

extension Node {
    /// Initialize a `Node` with a value of `NodeRepresentable`.
    ///
    /// - parameter representable: Value of `NodeRepresentable` to represent as a `Node`.
    ///
    /// - throws: `YamlError`.
    public init<T>(_ representable: T) throws where T: Yams.NodeRepresentable
}

extension Node: Yams.NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Yams.Node
}

extension Node.Mapping: Comparable {
    /// :nodoc:
    public static func < (lhs: Yams.Node.Mapping, rhs: Yams.Node.Mapping) -> Bool
}

extension Node.Mapping: Equatable {
    /// :nodoc:
    public static func == (lhs: Yams.Node.Mapping, rhs: Yams.Node.Mapping) -> Bool
}

extension Node.Mapping: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher)
}

extension Node.Mapping: ExpressibleByDictionaryLiteral {
    /// :nodoc:
    public init(dictionaryLiteral elements: (Yams.Node, Yams.Node)...)
}

extension Node.Mapping: MutableCollection {
    /// :nodoc:
    public typealias Element = (key: Yams.Node, value: Yams.Node)

    /// :nodoc:
    public func makeIterator() -> [Yams.Node.Mapping.Element].Iterator

    /// The index type for this mapping.
    public typealias Index = [Yams.Node.Mapping.Element].Index

    /// :nodoc:
    public var startIndex: Yams.Node.Mapping.Index { get }

    /// :nodoc:
    public var endIndex: Yams.Node.Mapping.Index { get }

    /// :nodoc:
    public func index(after index: Yams.Node.Mapping.Index) -> Yams.Node.Mapping.Index

    /// :nodoc:
    public subscript(index: Yams.Node.Mapping.Index) -> Yams.Node.Mapping.Element
}

extension Node.Mapping {
    /// This mapping's keys. Similar to `Dictionary.keys`.
    public var keys: LazyMapCollection<Yams.Node.Mapping, Yams.Node> { get }

    /// This mapping's keys. Similar to `Dictionary.keys`.
    public var values: LazyMapCollection<Yams.Node.Mapping, Yams.Node> { get }

    /// Set or get the `Node` for the specified string's `Node` representation.
    public subscript(string: String) -> Yams.Node?

    /// Set or get the specified `Node`.
    public subscript(node: Yams.Node) -> Yams.Node?

    /// Get the index of the specified `Node`, if it exists in the mapping.
    public func index(forKey key: Yams.Node) -> Yams.Node.Mapping.Index?
}

extension Node.Scalar: Comparable {
    /// :nodoc:
    public static func < (lhs: Yams.Node.Scalar, rhs: Yams.Node.Scalar) -> Bool
}

extension Node.Scalar: Equatable {
    /// :nodoc:
    public static func == (lhs: Yams.Node.Scalar, rhs: Yams.Node.Scalar) -> Bool
}

extension Node.Scalar: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher)
}

extension Node.Sequence: Comparable {
    /// :nodoc:
    public static func < (lhs: Yams.Node.Sequence, rhs: Yams.Node.Sequence) -> Bool
}

extension Node.Sequence: Equatable {
    /// :nodoc:
    public static func == (lhs: Yams.Node.Sequence, rhs: Yams.Node.Sequence) -> Bool
}

extension Node.Sequence: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher)
}

extension Node.Sequence: ExpressibleByArrayLiteral {
    /// :nodoc:
    public init(arrayLiteral elements: Yams.Node...)
}

extension Node.Sequence: MutableCollection {
    /// :nodoc:
    public func makeIterator() -> [Yams.Node].Iterator

    /// :nodoc:
    public typealias Index = [Yams.Node].Index

    /// :nodoc:
    public var startIndex: Yams.Node.Sequence.Index { get }

    /// :nodoc:
    public var endIndex: Yams.Node.Sequence.Index { get }

    /// :nodoc:
    public func index(after index: Yams.Node.Sequence.Index) -> Yams.Node.Sequence.Index

    /// :nodoc:
    public subscript(index: Yams.Node.Sequence.Index) -> Yams.Node

    /// :nodoc:
    public subscript(bounds: Range<Yams.Node.Sequence.Index>) -> [Yams.Node].SubSequence

    /// :nodoc:
    public var indices: [Yams.Node].Indices { get }
}

extension Node.Sequence: RandomAccessCollection {
    /// :nodoc:
    public func index(before index: Yams.Node.Sequence.Index) -> Yams.Node.Sequence.Index

    /// :nodoc:
    public func index(_ index: Yams.Node.Sequence.Index, offsetBy num: Int) -> Yams.Node.Sequence.Index

    /// :nodoc:
    public func distance(from start: Yams.Node.Sequence.Index, to end: Int) -> Yams.Node.Sequence.Index
}

extension Node.Sequence: RangeReplaceableCollection {
    /// :nodoc:
    public init()

    /// :nodoc:
    public mutating func replaceSubrange<C>(_ subrange: Range<Yams.Node.Sequence.Index>, with newElements: C) where C: Collection, C.Element == Yams.Node
}

/// Type is representable as `Node`.
public protocol NodeRepresentable {
    /// This value's `Node` representation.
    func represented() throws -> Yams.Node
}

/// Parses YAML strings.
public final class Parser {
    /// YAML string.
    public let yaml: String

    /// Resolver.
    public let resolver: Yams.Resolver

    /// Constructor.
    public let constructor: Yams.Constructor

    /// Encoding
    public enum Encoding: String {
        /// Use `YAML_UTF8_ENCODING`
        case utf8

        /// Use `YAML_UTF16(BE|LE)_ENCODING`
        case utf16

        /// The default encoding, determined at run time based on the String type's native encoding.
        /// This can be overridden by setting `YAMS_DEFAULT_ENCODING` to either `UTF8` or `UTF16`.
        /// This value is case insensitive.
        public static var `default`: Yams.Parser.Encoding
    }

    /// Encoding
    public let encoding: Yams.Parser.Encoding

    /// Set up Parser.
    ///
    /// - parameter string: YAML string.
    /// - parameter resolver: Resolver, `.default` if omitted.
    /// - parameter constructor: Constructor, `.default` if omitted.
    /// - parameter encoding: Encoding, `.default` if omitted.
    ///
    /// - throws: `YamlError`.
    public init(yaml string: String, resolver: Yams.Resolver = .default, constructor: Yams.Constructor = .default, encoding: Yams.Parser.Encoding = .default) throws

    /// Parse next document and return root Node.
    ///
    /// - returns: next Node.
    ///
    /// - throws: `YamlError`.
    public func nextRoot() throws -> Yams.Node?

    /// Parses the document expecting a single root Node and returns it.
    ///
    /// - returns: Single root Node.
    ///
    /// - throws: `YamlError`.
    public func singleRoot() throws -> Yams.Node?
}

/// Class used to resolve nodes to tags based on customizable rules.
public final class Resolver {
    /// Rule describing how to resolve tags from regex patterns.
    public struct Rule {
        /// The tag name this rule applies to.
        public let tag: Yams.Tag.Name

        /// The regex pattern used to resolve this rule.
        public var pattern: String { get }

        /// Create a rule with the specified tag name and regex pattern.
        ///
        /// - parameter tag: The tag name this rule should apply to.
        /// - parameter pattern: The regex pattern used to resolve this rule.
        ///
        /// - throws: Throws an error if the regular expression pattern is invalid.
        public init(_ tag: Yams.Tag.Name, _ pattern: String) throws
    }

    /// The rules used by this resolver to resolve nodes to tags.
    public let rules: [Yams.Resolver.Rule]

    /// Resolve a tag name from a given node.
    ///
    /// - parameter node: Node whose tag should be resolved.
    ///
    /// - returns: The resolved tag name.
    public func resolveTag(of node: Yams.Node) -> Yams.Tag.Name

    /// Returns a Resolver constructed by appending rule.
    public func appending(_ rule: Yams.Resolver.Rule) -> Yams.Resolver

    /// Returns a Resolver constructed by appending pattern for tag.
    public func appending(_ tag: Yams.Tag.Name, _ pattern: String) throws -> Yams.Resolver

    /// Returns a Resolver constructed by replacing rule.
    public func replacing(_ rule: Yams.Resolver.Rule) -> Yams.Resolver

    /// Returns a Resolver constructed by replacing pattern for tag.
    public func replacing(_ tag: Yams.Tag.Name, with pattern: String) throws -> Yams.Resolver

    /// Returns a Resolver constructed by removing pattern for tag.
    public func removing(_ tag: Yams.Tag.Name) -> Yams.Resolver
}

extension Resolver {
    /// Resolver with no rules.
    public static let basic: Yams.Resolver

    /// Resolver with a default set of rules.
    public static let `default`: Yams.Resolver
}

extension Resolver.Rule {
    /// Default bool resolver rule.
    public static let bool: Yams.Resolver.Rule

    /// Default int resolver rule.
    public static let int: Yams.Resolver.Rule

    /// Default float resolver rule.
    public static let float: Yams.Resolver.Rule

    /// Default merge resolver rule.
    public static let merge: Yams.Resolver.Rule

    /// Default null resolver rule.
    public static let null: Yams.Resolver.Rule

    /// Default timestamp resolver rule.
    public static let timestamp: Yams.Resolver.Rule

    /// Default value resolver rule.
    public static let value: Yams.Resolver.Rule
}

/// Types conforming to this protocol can be extracted `Node.Scalar`s.
public protocol ScalarConstructible {
    /// Construct an instance of `Self`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Self`, if possible.
    ///
    /// - returns: An instance of `Self`, if one was successfully extracted from the scalar.
    ///
    /// - note: We use static constructors to avoid overloading `init?(_ scalar: Node.Scalar)` which would
    ///         cause callsite ambiguities when using `init` as closure.
    static func construct(from scalar: Yams.Node.Scalar) -> Self?
}

extension ScalarConstructible where Self: FloatingPoint, Self: Yams.SexagesimalConvertible {
    /// Construct an instance of `FloatingPoint & SexagesimalConvertible`, if possible, from the specified
    /// scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type
    ///                     `FloatingPoint & SexagesimalConvertible`, if possible.
    ///
    /// - returns: An instance of `FloatingPoint & SexagesimalConvertible`, if one was successfully extracted
    ///            from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Self?
}

/// Type is representable as `Node.scalar`.
public protocol ScalarRepresentable: Yams.NodeRepresentable {
    /// This value's `Node.scalar` representation.
    func represented() -> Yams.Node.Scalar
}

extension ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() throws -> Yams.Node
}

/// Confirming types are convertible to base 60 numeric values.
public protocol SexagesimalConvertible: ExpressibleByIntegerLiteral {
    /// Creates a sexagesimal numeric value from the given string.
    ///
    /// - parameter string: The string from which to parse a sexagesimal value.
    ///
    /// - returns: A sexagesimal numeric value, if one was successfully parsed.
    static func create(from string: String) -> Self?

    /// Multiplies two sexagesimal numeric values.
    ///
    /// - parameter lhs: Left hand side multiplier.
    /// - parameter rhs: Right hand side multiplier.
    ///
    /// - returns: The result of the multiplication.
    static func * (lhs: Self, rhs: Self) -> Self

    /// Adds two sexagesimal numeric values.
    ///
    /// - parameter lhs: Left hand side adder.
    /// - parameter rhs: Right hand side adder.
    ///
    /// - returns: The result of the addition.
    static func + (lhs: Self, rhs: Self) -> Self
}

extension SexagesimalConvertible where Self: LosslessStringConvertible {
    /// Creates a sexagesimal numeric value from the given string.
    ///
    /// - parameter string: The string from which to parse a sexagesimal value.
    ///
    /// - returns: A sexagesimal numeric value, if one was successfully parsed.
    public static func create(from string: String) -> Self?
}

extension SexagesimalConvertible where Self: FixedWidthInteger {
    /// Creates a sexagesimal numeric value from the given string.
    ///
    /// - parameter string: The string from which to parse a sexagesimal value.
    ///
    /// - returns: A sexagesimal numeric value, if one was successfully parsed.
    public static func create(from string: String) -> Self?
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
    public static var implicit: Yams.Tag { get }

    /// Create a `Tag` with the specified name, resolver and constructor.
    ///
    /// - parameter name:        Tag name.
    /// - parameter resolver:    `Resolver` this tag should use, `.default` if omitted.
    /// - parameter constructor: `Constructor` this tag should use, `.default` if omitted.
    public init(_ name: Yams.Tag.Name, _ resolver: Yams.Resolver = .default, _ constructor: Yams.Constructor = .default)

    /// Lens returning a copy of the current `Tag` with the specified overridden changes.
    ///
    /// - note: Omitting or passing nil for a parameter will preserve the current `Tag`'s value in the copy.
    ///
    /// - parameter name:        Overridden tag name.
    /// - parameter resolver:    Overridden resolver.
    /// - parameter constructor: Overridden constructor.
    ///
    /// - returns: A copy of the current `Tag` with the specified overridden changes.
    public func copy(with name: Yams.Tag.Name? = nil, resolver: Yams.Resolver? = nil, constructor: Yams.Constructor? = nil) -> Yams.Tag
}

extension Tag: CustomStringConvertible {
    /// A textual representation of this tag.
    public var description: String { get }
}

extension Tag: Hashable {
    /// :nodoc:
    public func hash(into hasher: inout Hasher)

    /// :nodoc:
    public static func == (lhs: Yams.Tag, rhs: Yams.Tag) -> Bool
}

extension Tag.Name: ExpressibleByStringLiteral {
    /// :nodoc:
    public init(stringLiteral value: String)
}

extension Tag.Name: Hashable {}

extension Tag.Name {
    /// Tag should be resolved by value.
    public static let implicit: Yams.Tag.Name

    /// Tag should not be resolved by value, and be resolved as .str, .seq or .map.
    public static let nonSpecific: Yams.Tag.Name

    /// "tag:yaml.org,2002:str" <http://yaml.org/type/str.html>
    public static let str: Yams.Tag.Name

    /// "tag:yaml.org,2002:seq" <http://yaml.org/type/seq.html>
    public static let seq: Yams.Tag.Name

    /// "tag:yaml.org,2002:map" <http://yaml.org/type/map.html>
    public static let map: Yams.Tag.Name

    /// "tag:yaml.org,2002:bool" <http://yaml.org/type/bool.html>
    public static let bool: Yams.Tag.Name

    /// "tag:yaml.org,2002:float" <http://yaml.org/type/float.html>
    public static let float: Yams.Tag.Name

    /// "tag:yaml.org,2002:null" <http://yaml.org/type/null.html>
    public static let null: Yams.Tag.Name

    /// "tag:yaml.org,2002:int" <http://yaml.org/type/int.html>
    public static let int: Yams.Tag.Name

    /// "tag:yaml.org,2002:binary" <http://yaml.org/type/binary.html>
    public static let binary: Yams.Tag.Name

    /// "tag:yaml.org,2002:merge" <http://yaml.org/type/merge.html>
    public static let merge: Yams.Tag.Name

    /// "tag:yaml.org,2002:omap" <http://yaml.org/type/omap.html>
    public static let omap: Yams.Tag.Name

    /// "tag:yaml.org,2002:pairs" <http://yaml.org/type/pairs.html>
    public static let pairs: Yams.Tag.Name

    /// "tag:yaml.org,2002:set". <http://yaml.org/type/set.html>
    public static let set: Yams.Tag.Name

    /// "tag:yaml.org,2002:timestamp" <http://yaml.org/type/timestamp.html>
    public static let timestamp: Yams.Tag.Name

    /// "tag:yaml.org,2002:value" <http://yaml.org/type/value.html>
    public static let value: Yams.Tag.Name

    /// "tag:yaml.org,2002:yaml" <http://yaml.org/type/yaml.html> We don't support this.
    public static let yaml: Yams.Tag.Name
}

/// `Codable`-style `Decoder` that can be used to decode a `Decodable` type from a given `String` and optional
/// user info mapping. Similar to `Foundation.JSONDecoder`.
public class YAMLDecoder {
    /// Creates a `YAMLDecoder` instance.
    ///
    /// - parameter encoding: Encoding, `.default` if omitted.
    public init(encoding: Yams.Parser.Encoding = .default)

    /// Decode a `Decodable` type from a given `String` and optional user info mapping.
    ///
    /// - parameter type:    `Decodable` type to decode.
    /// - parameter yaml:     YAML string to decode.
    /// - parameter userInfo: Additional key/values which can be used when looking up keys to decode.
    ///
    /// - returns: Returns the decoded type `T`.
    ///
    /// - throws: `DecodingError` if something went wrong while decoding.
    public func decode<T>(_ type: T.Type = T.self, from yaml: String, userInfo: [CodingUserInfoKey: Any] = [:]) throws -> T where T: Decodable

    /// Encoding
    public var encoding: Yams.Parser.Encoding
}

// MARK: - ScalarRepresentableCustomizedForCodable

/// Types conforming to this protocol can be encoded by `YamlEncoder`.
public protocol YAMLEncodable: Encodable {
    /// Returns this value wrapped in a `Node`.
    func box() -> Yams.Node
}

extension YAMLEncodable where Self: Yams.ScalarRepresentable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Yams.Node
}

/// `Codable`-style `Encoder` that can be used to encode an `Encodable` type to a YAML string using optional
/// user info mapping. Similar to `Foundation.JSONEncoder`.
public class YAMLEncoder {
    /// Options to use when encoding to YAML.
    public typealias Options = Yams.Emitter.Options

    /// Options to use when encoding to YAML.
    public var options: Yams.YAMLEncoder.Options

    /// Creates a `YAMLEncoder` instance.
    public init()

    /// Encode a value of type `T` to a YAML string.
    ///
    /// - parameter value:    Value to encode.
    /// - parameter userInfo: Additional key/values which can be used when looking up keys to encode.
    ///
    /// - returns: The YAML string.
    ///
    /// - throws: `EncodingError` if something went wrong while encoding.
    public func encode<T>(_ value: T, userInfo: [CodingUserInfoKey: Any] = [:]) throws -> String where T: Encodable
}

/// Errors thrown by Yams APIs.
public enum YamlError: Error {
    /// `YAML_NO_ERROR`. No error is produced.
    case no

    /// `YAML_MEMORY_ERROR`. Cannot allocate or reallocate a block of memory.
    case memory

    /// `YAML_READER_ERROR`. Cannot read or decode the input stream.
    ///
    /// - parameter problem: Error description.
    /// - parameter offset:  The offset from `yaml.startIndex` at which the problem occured.
    /// - parameter value:   The problematic value (-1 is none).
    /// - parameter yaml:    YAML String which the problem occured while reading.
    case reader(problem: String, offset: Int?, value: Int32, yaml: String)

    /// `YAML_SCANNER_ERROR`. Cannot scan the input stream.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while scanning.
    case scanner(context: Yams.YamlError.Context?, problem: String, Yams.Mark, yaml: String)

    /// `YAML_PARSER_ERROR`. Cannot parse the input stream.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while parsing.
    case parser(context: Yams.YamlError.Context?, problem: String, Yams.Mark, yaml: String)

    /// `YAML_COMPOSER_ERROR`. Cannot compose a YAML document.
    ///
    /// - parameter context: Error context.
    /// - parameter problem: Error description.
    /// - parameter mark:    Problem position.
    /// - parameter yaml:    YAML String which the problem occured while composing.
    case composer(context: Yams.YamlError.Context?, problem: String, Yams.Mark, yaml: String)

    /// `YAML_WRITER_ERROR`. Cannot write to the output stream.
    ///
    /// - parameter problem: Error description.
    case writer(problem: String)

    /// `YAML_EMITTER_ERROR`. Cannot emit a YAML stream.
    ///
    /// - parameter problem: Error description.
    case emitter(problem: String)

    /// Used in `NodeRepresentable`.
    ///
    /// - parameter problem: Error description.
    case representer(problem: String)

    /// The error context.
    public struct Context: CustomStringConvertible {
        /// Context text.
        public let text: String

        /// Context position.
        public let mark: Yams.Mark

        /// A textual representation of this instance.
        public var description: String { get }
    }
}

extension YamlError: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String { get }
}

/// Sequence that holds an error.
public struct YamlSequence<T>: Sequence, IteratorProtocol {
    /// This sequence's error, if any.
    public private(set) var error: Error? {
        get
    }

    /// `Swift.Sequence.next()`.
    public mutating func next() -> T?
}

/// Parse the first YAML document in a String
/// and produce the corresponding representation tree.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: Node?
///
/// - throws: YamlError
public func compose(yaml: String, _ resolver: Yams.Resolver = .default, _ constructor: Yams.Constructor = .default, _ encoding: Yams.Parser.Encoding = .default) throws -> Yams.Node?

/// Parse all YAML documents in a String
/// and produce corresponding representation trees.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: YamlSequence<Node>
///
/// - throws: YamlError
public func compose_all(yaml: String, _ resolver: Yams.Resolver = .default, _ constructor: Yams.Constructor = .default, _ encoding: Yams.Parser.Encoding = .default) throws -> Yams.YamlSequence<Yams.Node>

/// Produce a YAML string from objects.
///
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
///
/// - returns: YAML string.
///
/// - throws: `YamlError`.
public func dump<Objects>(objects: Objects, canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, explicitStart: Bool = false, explicitEnd: Bool = false, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false) throws -> String where Objects: Sequence

/// Produce a YAML string from an object.
///
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
///
/// - returns: YAML string.
///
/// - throws: `YamlError`.
public func dump(object: Any?, canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, explicitStart: Bool = false, explicitEnd: Bool = false, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false) throws -> String

/// Parse the first YAML document in a String
/// and produce the corresponding Swift object.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: Any?
///
/// - throws: YamlError
public func load(yaml: String, _ resolver: Yams.Resolver = .default, _ constructor: Yams.Constructor = .default, _ encoding: Yams.Parser.Encoding = .default) throws -> Any?

/// Parse all YAML documents in a String
/// and produce corresponding Swift objects.
///
/// - parameter yaml: String
/// - parameter resolver: Resolver
/// - parameter constructor: Constructor
/// - parameter encoding: Parser.Encoding
///
/// - returns: YamlSequence<Any>
///
/// - throws: YamlError
public func load_all(yaml: String, _ resolver: Yams.Resolver = .default, _ constructor: Yams.Constructor = .default, _ encoding: Yams.Parser.Encoding = .default) throws -> Yams.YamlSequence<Any>

/// Produce a YAML string from a `Node`.
///
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
///
/// - returns: YAML string.
///
/// - throws: `YamlError`.
public func serialize<Nodes>(nodes: Nodes, canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, explicitStart: Bool = false, explicitEnd: Bool = false, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false) throws -> String where Nodes: Sequence, Nodes.Element == Yams.Node

/// Produce a YAML string from a `Node`.
///
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
///
/// - returns: YAML string.
///
/// - throws: `YamlError`.
public func serialize(node: Yams.Node, canonical: Bool = false, indent: Int = 0, width: Int = 0, allowUnicode: Bool = false, lineBreak: Yams.Emitter.LineBreak = .ln, explicitStart: Bool = false, explicitEnd: Bool = false, version: (major: Int, minor: Int)? = nil, sortKeys: Bool = false) throws -> String

extension Bool: Yams.ScalarConstructible {
    /// Construct an instance of `Bool`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Bool`, if possible.
    ///
    /// - returns: An instance of `Bool`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Bool?
}

extension Data: Yams.ScalarConstructible {
    /// Construct an instance of `Data`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Data`, if possible.
    ///
    /// - returns: An instance of `Data`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Data?
}

extension Date: Yams.ScalarConstructible {
    /// Construct an instance of `Date`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Date`, if possible.
    ///
    /// - returns: An instance of `Date`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Date?
}

extension Double: Yams.ScalarConstructible {}

extension Float: Yams.ScalarConstructible {}

extension Int: Yams.ScalarConstructible {
    /// Construct an instance of `Int`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Int`, if possible.
    ///
    /// - returns: An instance of `Int`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Int?
}

extension UInt: Yams.ScalarConstructible {
    /// Construct an instance of `UInt`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `UInt`, if possible.
    ///
    /// - returns: An instance of `UInt`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> UInt?
}

extension Int64: Yams.ScalarConstructible {
    /// Construct an instance of `Int64`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Int64`, if possible.
    ///
    /// - returns: An instance of `Int64`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Int64?
}

extension UInt64: Yams.ScalarConstructible {
    /// Construct an instance of `UInt64`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `UInt64`, if possible.
    ///
    /// - returns: An instance of `UInt64`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> UInt64?
}

extension String: Yams.ScalarConstructible {
    /// Construct an instance of `String`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `String`, if possible.
    ///
    /// - returns: An instance of `String`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> String?

    /// Construct an instance of `String`, if possible, from the specified `Node`.
    ///
    /// - parameter node: The `Node` from which to extract a value of type `String`, if possible.
    ///
    /// - returns: An instance of `String`, if one was successfully extracted from the node.
    public static func construct(from node: Yams.Node) -> String?
}

extension NSNull {
    /// Construct an instance of `NSNull`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `NSNull`, if possible.
    ///
    /// - returns: An instance of `NSNull`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> NSNull?
}

extension Dictionary {
    /// Construct a `Dictionary`, if possible, from the specified mapping.
    ///
    /// - parameter mapping: The `Node.Mapping` from which to extract a `Dictionary`, if possible.
    ///
    /// - returns: An instance of `[AnyHashable: Any]`, if one was successfully extracted from the mapping.
    public static func construct_mapping(from mapping: Yams.Node.Mapping) -> [AnyHashable: Any]?
}

extension Set {
    /// Construct a `Set`, if possible, from the specified mapping.
    ///
    /// - parameter mapping: The `Node.Mapping` from which to extract a `Set`, if possible.
    ///
    /// - returns: An instance of `Set<AnyHashable>`, if one was successfully extracted from the mapping.
    public static func construct_set(from mapping: Yams.Node.Mapping) -> Set<AnyHashable>?
}

extension Array {
    /// Construct an Array of `Any` from the specified `sequence`.
    ///
    /// - parameter sequence: Sequence to convert to `Array<Any>`.
    ///
    /// - returns: Array of `Any`.
    public static func construct_seq(from sequence: Yams.Node.Sequence) -> [Any]

    /// Construct an "O-map" (array of `(Any, Any)` tuples) from the specified `sequence`.
    ///
    /// - parameter sequence: Sequence to convert to `Array<(Any, Any)>`.
    ///
    /// - returns: Array of `(Any, Any)` tuples.
    public static func construct_omap(from sequence: Yams.Node.Sequence) -> [(Any, Any)]

    /// Construct an array of `(Any, Any)` tuples from the specified `sequence`.
    ///
    /// - parameter sequence: Sequence to convert to `Array<(Any, Any)>`.
    ///
    /// - returns: Array of `(Any, Any)` tuples.
    public static func construct_pairs(from sequence: Yams.Node.Sequence) -> [(Any, Any)]
}

extension Double: Yams.SexagesimalConvertible {}

extension Float: Yams.SexagesimalConvertible {}

extension Int: Yams.SexagesimalConvertible {}

extension UInt: Yams.SexagesimalConvertible {}

extension Int64: Yams.SexagesimalConvertible {}

extension UInt64: Yams.SexagesimalConvertible {}

extension FixedWidthInteger where Self: SignedInteger {
    /// Construct an instance of `Self`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Self`, if possible.
    ///
    /// - returns: An instance of `Self`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Self?
}

extension FixedWidthInteger where Self: UnsignedInteger {
    /// Construct an instance of `Self`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Self`, if possible.
    ///
    /// - returns: An instance of `Self`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Self?
}

extension Int8: Yams.ScalarConstructible {}

extension Int16: Yams.ScalarConstructible {}

extension Int32: Yams.ScalarConstructible {}

extension UInt8: Yams.ScalarConstructible {}

extension UInt16: Yams.ScalarConstructible {}

extension UInt32: Yams.ScalarConstructible {}

extension Decimal: Yams.ScalarConstructible {
    /// Construct an instance of `Decimal`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `Decimal`, if possible.
    ///
    /// - returns: An instance of `Decimal`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> Decimal?
}

extension URL: Yams.ScalarConstructible {
    /// Construct an instance of `URL`, if possible, from the specified scalar.
    ///
    /// - parameter scalar: The `Node.Scalar` from which to extract a value of type `URL`, if possible.
    ///
    /// - returns: An instance of `URL`, if one was successfully extracted from the scalar.
    public static func construct(from scalar: Yams.Node.Scalar) -> URL?
}

extension Array: Yams.NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Yams.Node
}

extension Dictionary: Yams.NodeRepresentable {
    /// This value's `Node` representation.
    public func represented() throws -> Yams.Node
}

extension Bool: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Data: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Date: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Double: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Float: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension BinaryInteger {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Int: Yams.ScalarRepresentable {}

extension Int16: Yams.ScalarRepresentable {}

extension Int32: Yams.ScalarRepresentable {}

extension Int64: Yams.ScalarRepresentable {}

extension Int8: Yams.ScalarRepresentable {}

extension UInt: Yams.ScalarRepresentable {}

extension UInt16: Yams.ScalarRepresentable {}

extension UInt32: Yams.ScalarRepresentable {}

extension UInt64: Yams.ScalarRepresentable {}

extension UInt8: Yams.ScalarRepresentable {}

extension Optional: Yams.NodeRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() throws -> Yams.Node
}

extension Decimal: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension URL: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension String: Yams.ScalarRepresentable {
    /// This value's `Node.scalar` representation.
    public func represented() -> Yams.Node.Scalar
}

extension Bool: Yams.YAMLEncodable {}

extension Data: Yams.YAMLEncodable {}

extension Decimal: Yams.YAMLEncodable {}

extension Int: Yams.YAMLEncodable {}

extension Int8: Yams.YAMLEncodable {}

extension Int16: Yams.YAMLEncodable {}

extension Int32: Yams.YAMLEncodable {}

extension Int64: Yams.YAMLEncodable {}

extension UInt: Yams.YAMLEncodable {}

extension UInt8: Yams.YAMLEncodable {}

extension UInt16: Yams.YAMLEncodable {}

extension UInt32: Yams.YAMLEncodable {}

extension UInt64: Yams.YAMLEncodable {}

extension URL: Yams.YAMLEncodable {}

extension String: Yams.YAMLEncodable {}

extension Date: Yams.YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Yams.Node
}

extension Double: Yams.YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Yams.Node
}

extension Float: Yams.YAMLEncodable {
    /// Returns this value wrapped in a `Node.scalar`.
    public func box() -> Yams.Node
}
