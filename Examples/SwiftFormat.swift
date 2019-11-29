import Foundation
import SwiftOnoneSupport

/// Argument type for stripping
public enum ArgumentStrippingMode: String {
    case unnamedOnly

    case closureOnly

    case all
}

/// Public interface for the SwiftFormat command-line functions
public struct CLI {
    /// Output type for printed content
    public enum OutputType {
        case info

        case success

        case error

        case warning

        case content

        case raw
    }

    /// Output handler - override this to intercept output from the CLI
    public static var print: (String, SwiftFormat.CLI.OutputType) -> Void

    /// Input handler - override this to inject input into the CLI
    /// Injected lines should include the terminating newline character
    public static var readLine: () -> String?

    /// Run the CLI with the specified input arguments
    public static func run(in directory: String, with args: [String] = CommandLine.arguments) -> SwiftFormat.ExitCode

    /// Run the CLI with the specified input string (this will be parsed into multiple arguments)
    public static func run(in directory: String, with argumentString: String) -> SwiftFormat.ExitCode
}

public enum ExitCode: Int32 {
    case ok

    case lintFailure

    case error
}

/// Callback for enumerateFiles() function
public typealias FileEnumerationHandler = (URL, URL, SwiftFormat.Options) throws -> () throws -> Void

/// File info, used for constructing header comments
public struct FileInfo: Equatable {
    public init(fileName: String? = nil, creationDate: Date? = nil)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftFormat.FileInfo, rhs: SwiftFormat.FileInfo) -> Bool
}

/// File enumeration options
public struct FileOptions {
    public var followSymlinks: Bool

    public var supportedFileExtensions: [String]

    public var excludedGlobs: [SwiftFormat.Glob]

    public var unexcludedGlobs: [SwiftFormat.Glob]

    @available(*, deprecated, message: "Use excludedGlobs property instead")
    public var excludedURLs: [URL] { get }

    public static let `default`: SwiftFormat.FileOptions

    @available(*, deprecated, message: "Use other init() method instead")
    public init(followSymlinks: Bool = false, supportedFileExtensions: [String] = ["swift"], excludedURLs: [URL])

    public init(followSymlinks: Bool = false, supportedFileExtensions: [String] = ["swift"], excludedGlobs: [SwiftFormat.Glob] = [], unexcludedGlobs: [SwiftFormat.Glob] = [])
}

/// An enumeration of the types of error that may be thrown by SwiftFormat
public enum FormatError: Error, CustomStringConvertible, LocalizedError, CustomNSError {
    case reading(String)

    case writing(String)

    case parsing(String)

    case options(String)

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

    public var localizedDescription: String { get }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] { get }
}

/// Configuration options for formatting. These aren't actually used by the
/// Formatter class itself, but it makes them available to the format rules.
public struct FormatOptions: CustomStringConvertible {
    public var indent: String

    public var linebreak: String

    public var allowInlineSemicolons: Bool

    public var spaceAroundRangeOperators: Bool

    public var spaceAroundOperatorDeclarations: Bool

    public var useVoid: Bool

    public var indentCase: Bool

    public var trailingCommas: Bool

    public var indentComments: Bool

    public var truncateBlankLines: Bool

    public var insertBlankLines: Bool

    public var removeBlankLines: Bool

    public var allmanBraces: Bool

    public var fileHeader: SwiftFormat.HeaderStrippingMode

    public var ifdefIndent: SwiftFormat.IndentMode

    public var wrapArguments: SwiftFormat.WrapMode

    public var wrapCollections: SwiftFormat.WrapMode

    public var closingParenOnSameLine: Bool

    public var uppercaseHex: Bool

    public var uppercaseExponent: Bool

    public var decimalGrouping: SwiftFormat.Grouping

    public var binaryGrouping: SwiftFormat.Grouping

    public var octalGrouping: SwiftFormat.Grouping

    public var hexGrouping: SwiftFormat.Grouping

    public var fractionGrouping: Bool

    public var exponentGrouping: Bool

    public var hoistPatternLet: Bool

    public var stripUnusedArguments: SwiftFormat.ArgumentStrippingMode

    public var elseOnNextLine: Bool

    public var explicitSelf: SwiftFormat.SelfMode

    public var selfRequired: [String]

    public var experimentalRules: Bool

    public var importGrouping: SwiftFormat.ImportGrouping

    public var trailingClosures: [String]

    public var xcodeIndentation: Bool

    public var fragment: Bool

    public var ignoreConflictMarkers: Bool

    public var swiftVersion: SwiftFormat.Version

    public var fileInfo: SwiftFormat.FileInfo

    public static let `default`: SwiftFormat.FormatOptions

    public init(indent: String = "    ", linebreak: String = "\n", allowInlineSemicolons: Bool = true, spaceAroundRangeOperators: Bool = true, spaceAroundOperatorDeclarations: Bool = true, useVoid: Bool = true, indentCase: Bool = false, trailingCommas: Bool = true, indentComments: Bool = true, truncateBlankLines: Bool = true, insertBlankLines: Bool = true, removeBlankLines: Bool = true, allmanBraces: Bool = false, fileHeader: SwiftFormat.HeaderStrippingMode = .ignore, ifdefIndent: SwiftFormat.IndentMode = .indent, wrapArguments: SwiftFormat.WrapMode = .preserve, wrapCollections: SwiftFormat.WrapMode = .preserve, closingParenOnSameLine: Bool = false, uppercaseHex: Bool = true, uppercaseExponent: Bool = false, decimalGrouping: SwiftFormat.Grouping = .group(3, 6), binaryGrouping: SwiftFormat.Grouping = .group(4, 8), octalGrouping: SwiftFormat.Grouping = .group(4, 8), hexGrouping: SwiftFormat.Grouping = .group(4, 8), fractionGrouping: Bool = false, exponentGrouping: Bool = false, hoistPatternLet: Bool = true, stripUnusedArguments: SwiftFormat.ArgumentStrippingMode = .all, elseOnNextLine: Bool = false, explicitSelf: SwiftFormat.SelfMode = .remove, selfRequired: [String] = [], experimentalRules: Bool = false, importGrouping: SwiftFormat.ImportGrouping = .alphabetized, trailingClosures: [String] = [], xcodeIndentation: Bool = false, fragment: Bool = false, ignoreConflictMarkers: Bool = false, swiftVersion: SwiftFormat.Version = .undefined, fileInfo: SwiftFormat.FileInfo = FileInfo())

    public var allOptions: [String: Any] { get }

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

public final class FormatRule {
    public func apply(with formatter: SwiftFormat.Formatter)
}

public let FormatRules: SwiftFormat._FormatRules

/// This is a utility class used for manipulating a tokenized source file.
/// It doesn't actually contain any logic for formatting, but provides
/// utility methods for enumerating and adding/removing/replacing tokens.
/// The primary advantage it provides over operating on the token array
/// directly is that it allows mutation during enumeration, and
/// transparently handles changes that affect the current token index.
public class Formatter: NSObject {
    /// The options that the formatter was initialized with
    public let options: SwiftFormat.FormatOptions

    /// The token array managed by the formatter (read-only)
    public private(set) var tokens: [SwiftFormat.Token] {
        get
    }

    /// Create a new formatter instance from a token array
    public init(_ tokens: [SwiftFormat.Token], options: SwiftFormat.FormatOptions = FormatOptions())

    /// Returns the token at the specified index, or nil if index is invalid
    public func token(at index: Int) -> SwiftFormat.Token?

    /// Replaces the token at the specified index with one or more new tokens
    public func replaceToken(at index: Int, with tokens: SwiftFormat.Token...)

    /// Replaces the tokens in the specified range with new tokens
    public func replaceTokens(inRange range: Range<Int>, with tokens: [SwiftFormat.Token])

    /// Replaces the tokens in the specified closed range with new tokens
    public func replaceTokens(inRange range: ClosedRange<Int>, with tokens: [SwiftFormat.Token])

    /// Removes the token at the specified index
    public func removeToken(at index: Int)

    /// Removes the tokens in the specified range
    public func removeTokens(inRange range: Range<Int>)

    /// Removes the tokens in the specified closed range
    public func removeTokens(inRange range: ClosedRange<Int>)

    /// Removes the last token
    public func removeLastToken()

    /// Inserts an array of tokens at the specified index
    public func insertTokens(_ tokens: [SwiftFormat.Token], at index: Int)

    /// Inserts a single token at the specified index
    public func insertToken(_ token: SwiftFormat.Token, at index: Int)

    /// Loops through each token in the array. It is safe to mutate the token
    /// array inside the body block, but note that the index and token arguments
    /// may not reflect the current token any more after a mutation
    public func forEachToken(_ body: (Int, SwiftFormat.Token) -> Void)

    /// As above, but only loops through tokens that match the specified filter block
    public func forEachToken(where matching: (SwiftFormat.Token) -> Bool, _ body: (Int, SwiftFormat.Token) -> Void)

    /// As above, but only loops through tokens with the specified type and string
    public func forEach(_ token: SwiftFormat.Token, _ body: (Int, SwiftFormat.Token) -> Void)

    /// As above, but only loops through tokens with the specified type and string
    public func forEach(_ type: SwiftFormat.TokenType, _ body: (Int, SwiftFormat.Token) -> Void)

    /// Returns the index of the next token in the specified range that matches the block
    public func index(in range: CountableRange<Int>, where matches: (SwiftFormat.Token) -> Bool) -> Int?

    /// Returns the index of the next token at the current scope that matches the block
    public func index(after index: Int, where matches: (SwiftFormat.Token) -> Bool) -> Int?

    /// Returns the index of the next matching token in the specified range
    public func index(of token: SwiftFormat.Token, in range: CountableRange<Int>) -> Int?

    /// Returns the index of the next matching token at the current scope
    public func index(of token: SwiftFormat.Token, after index: Int) -> Int?

    /// Returns the index of the next token in the specified range of the specified type
    public func index(of type: SwiftFormat.TokenType, in range: CountableRange<Int>, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> Int?

    /// Returns the index of the next token at the current scope of the specified type
    public func index(of type: SwiftFormat.TokenType, after index: Int, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> Int?

    /// Returns the next token at the current scope that matches the block
    public func nextToken(after index: Int, where matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> SwiftFormat.Token?

    /// Returns the next token at the current scope of the specified type
    public func next(_ type: SwiftFormat.TokenType, after index: Int, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> SwiftFormat.Token?

    /// Returns the next token in the specified range of the specified type
    public func next(_ type: SwiftFormat.TokenType, in range: CountableRange<Int>, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> SwiftFormat.Token?

    /// Returns the index of the last token in the specified range that matches the block
    public func lastIndex(in range: CountableRange<Int>, where matches: (SwiftFormat.Token) -> Bool) -> Int?

    /// Returns the index of the previous token at the current scope that matches the block
    public func index(before index: Int, where matches: (SwiftFormat.Token) -> Bool) -> Int?

    /// Returns the index of the last matching token in the specified range
    public func lastIndex(of token: SwiftFormat.Token, in range: CountableRange<Int>) -> Int?

    /// Returns the index of the previous matching token at the current scope
    public func index(of token: SwiftFormat.Token, before index: Int) -> Int?

    /// Returns the index of the last token in the specified range of the specified type
    public func lastIndex(of type: SwiftFormat.TokenType, in range: CountableRange<Int>, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> Int?

    /// Returns the index of the previous token at the current scope of the specified type
    public func index(of type: SwiftFormat.TokenType, before index: Int, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> Int?

    /// Returns the previous token at the current scope that matches the block
    public func lastToken(before index: Int, where matches: (SwiftFormat.Token) -> Bool) -> SwiftFormat.Token?

    /// Returns the previous token at the current scope of the specified type
    public func last(_ type: SwiftFormat.TokenType, before index: Int, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> SwiftFormat.Token?

    /// Returns the previous token in the specified range of the specified type
    public func last(_ type: SwiftFormat.TokenType, in range: CountableRange<Int>, if matches: (SwiftFormat.Token) -> Bool = { _ in true }) -> SwiftFormat.Token?

    /// Returns the starting token for the containing scope at the specified index
    public func currentScope(at index: Int) -> SwiftFormat.Token?

    public func endOfScope(at index: Int) -> Int?

    /// Returns the index of the first token of the line containing the specified index
    public func startOfLine(at index: Int) -> Int

    /// Returns the space at the start of the line containing the specified index
    public func indentForLine(at index: Int) -> String
}

/// Glob type represents either an exact path or wildcard
public enum Glob: CustomStringConvertible {
    case path(String)

    case regex(NSRegularExpression)

    public func matches(_ path: String) -> Bool

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

/// Grouping for numeric literals
public enum Grouping: Equatable, RawRepresentable, CustomStringConvertible {
    case ignore

    case none

    case group(Int, Int)

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: String { get }

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

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftFormat.Grouping, rhs: SwiftFormat.Grouping) -> Bool
}

/// Argument type for stripping
public enum HeaderStrippingMode: Equatable, RawRepresentable, ExpressibleByStringLiteral {
    case ignore

    case replace(String)

    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String)

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: String { get }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftFormat.HeaderStrippingMode, rhs: SwiftFormat.HeaderStrippingMode) -> Bool
}

/// Grouping for sorting imports
public enum ImportGrouping: String {
    case alphabetized

    case testableTop

    case testableBottom
}

/// The indenting mode to use for #if/#endif statements
public enum IndentMode: String {
    case indent

    case noIndent

    case outdent

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)
}

/// Numeric literal types
public enum NumberType {
    case integer

    case decimal

    case binary

    case octal

    case hex
}

/// Symbol/operator types
public enum OperatorType {
    case none

    case infix

    case prefix

    case postfix
}

/// All options
public struct Options {
    public var fileOptions: SwiftFormat.FileOptions?

    public var formatOptions: SwiftFormat.FormatOptions?

    public var rules: Set<String>?

    public static let `default`: SwiftFormat.Options

    public init(fileOptions: SwiftFormat.FileOptions? = nil, formatOptions: SwiftFormat.FormatOptions? = nil, rules: Set<String>? = nil)
}

/// Self insertion mode
public enum SelfMode: String {
    case insert

    case remove

    case initOnly
}

/// All token types
public enum Token: Equatable {
    case number(String, SwiftFormat.NumberType)

    case linebreak(String)

    case startOfScope(String)

    case endOfScope(String)

    case delimiter(String)

    case `operator`(String, SwiftFormat.OperatorType)

    case stringBody(String)

    case keyword(String)

    case identifier(String)

    case space(String)

    case commentBody(String)

    case error(String)

    /// The original token string
    public var string: String { get }

    /// Returns the unescaped token string
    public func unescaped() -> String

    /// Test if token is of the specified type
    public func `is`(_ type: SwiftFormat.TokenType) -> Bool

    public var isAttribute: Bool { get }

    public var isDelimiter: Bool { get }

    public var isOperator: Bool { get }

    public var isUnwrapOperator: Bool { get }

    public var isRangeOperator: Bool { get }

    public var isNumber: Bool { get }

    public var isError: Bool { get }

    public var isStartOfScope: Bool { get }

    public var isEndOfScope: Bool { get }

    public var isKeyword: Bool { get }

    public var isIdentifier: Bool { get }

    public var isIdentifierOrKeyword: Bool { get }

    public var isSpace: Bool { get }

    public var isLinebreak: Bool { get }

    public var isEndOfStatement: Bool { get }

    public var isSpaceOrLinebreak: Bool { get }

    public var isSpaceOrComment: Bool { get }

    public var isSpaceOrCommentOrLinebreak: Bool { get }

    public var isCommentOrLinebreak: Bool { get }

    public func isOperator(_ string: String) -> Bool

    public func isOperator(ofType type: SwiftFormat.OperatorType) -> Bool

    public var isComment: Bool { get }

    public var isStringDelimiter: Bool { get }

    public var isMultilineStringDelimiter: Bool { get }

    public func isEndOfScope(_ token: SwiftFormat.Token) -> Bool

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftFormat.Token, rhs: SwiftFormat.Token) -> Bool
}

/// Classes of token used for matching
public enum TokenType {
    case space

    case linebreak

    case endOfStatement

    case startOfScope

    case endOfScope

    case keyword

    case delimiter

    case identifier

    case attribute

    case `operator`

    case unwrapOperator

    case rangeOperator

    case number

    case error

    case spaceOrComment

    case spaceOrLinebreak

    case spaceOrCommentOrLinebreak

    case identifierOrKeyword

    case nonSpace

    case nonSpaceOrComment

    case nonSpaceOrLinebreak

    case nonSpaceOrCommentOrLinebreak
}

/// Version number wrapper
public struct Version: RawRepresentable, Comparable, ExpressibleByStringLiteral {
    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public let rawValue: String

    public static let undefined: SwiftFormat.Version

    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String)

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftFormat.Version, rhs: SwiftFormat.Version) -> Bool

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: SwiftFormat.Version, rhs: SwiftFormat.Version) -> Bool
}

/// Wrap mode for arguments
public enum WrapMode: String {
    case beforeFirst

    case afterFirst

    case preserve

    case disabled

    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init?(rawValue: String)
}

public struct _FormatRules {
    /// Implement the following rules with respect to the spacing around parens:
    /// * There is no space between an opening paren and the preceding identifier,
    ///   unless the identifier is one of the specified keywords
    /// * There is no space between an opening paren and the preceding closing brace
    /// * There is no space between an opening paren and the preceding closing square bracket
    /// * There is space between a closing paren and following identifier
    /// * There is space between a closing paren and following opening brace
    /// * There is no space between a closing paren and following opening square bracket
    public let spaceAroundParens: SwiftFormat.FormatRule

    /// Remove space immediately inside parens
    public let spaceInsideParens: SwiftFormat.FormatRule

    /// Implement the following rules with respect to the spacing around square brackets:
    /// * There is no space between an opening bracket and the preceding identifier,
    ///   unless the identifier is one of the specified keywords
    /// * There is no space between an opening bracket and the preceding closing brace
    /// * There is no space between an opening bracket and the preceding closing square bracket
    /// * There is space between a closing bracket and following identifier
    /// * There is space between a closing bracket and following opening brace
    public let spaceAroundBrackets: SwiftFormat.FormatRule

    /// Remove space immediately inside square brackets
    public let spaceInsideBrackets: SwiftFormat.FormatRule

    /// Ensure that there is space between an opening brace and the preceding
    /// identifier, and between a closing brace and the following identifier.
    public let spaceAroundBraces: SwiftFormat.FormatRule

    /// Ensure that there is space immediately inside braces
    public let spaceInsideBraces: SwiftFormat.FormatRule

    /// Ensure there is no space between an opening chevron and the preceding identifier
    public let spaceAroundGenerics: SwiftFormat.FormatRule

    /// Remove space immediately inside chevrons
    public let spaceInsideGenerics: SwiftFormat.FormatRule

    /// Implement the following rules with respect to the spacing around operators:
    /// * Infix operators are separated from their operands by a space on either
    ///   side. Does not affect prefix/postfix operators, as required by syntax.
    /// * Delimiters, such as commas and colons, are consistently followed by a
    ///   single space, unless it appears at the end of a line, and is not
    ///   preceded by a space, unless it appears at the beginning of a line.
    public let spaceAroundOperators: SwiftFormat.FormatRule

    /// Add space around comments, except at the start or end of a line
    public let spaceAroundComments: SwiftFormat.FormatRule

    /// Add space inside comments, taking care not to mangle headerdoc or
    /// carefully preformatted comments, such as star boxes, etc.
    public let spaceInsideComments: SwiftFormat.FormatRule

    /// Adds or removes the space around range operators
    public let ranges: SwiftFormat.FormatRule

    /// Collapse all consecutive space characters to a single space, except at
    /// the start of a line or inside a comment or string, as these have no semantic
    /// meaning and lead to noise in commits.
    public let consecutiveSpaces: SwiftFormat.FormatRule

    /// Remove trailing space from the end of lines, as it has no semantic
    /// meaning and leads to noise in commits.
    public let trailingSpace: SwiftFormat.FormatRule

    /// Collapse all consecutive blank lines into a single blank line
    public let consecutiveBlankLines: SwiftFormat.FormatRule

    /// Remove blank lines immediately after an opening brace, bracket, paren or chevron
    public let blankLinesAtStartOfScope: SwiftFormat.FormatRule

    /// Remove blank lines immediately before a closing brace, bracket, paren or chevron
    /// unless it's followed by more code on the same line (e.g. } else { )
    public let blankLinesAtEndOfScope: SwiftFormat.FormatRule

    /// Adds a blank line immediately after a closing brace, unless followed by another closing brace
    public let blankLinesBetweenScopes: SwiftFormat.FormatRule

    /// Adds a blank line around MARK: comments
    public let blankLinesAroundMark: SwiftFormat.FormatRule

    /// Always end file with a linebreak, to avoid incompatibility with certain unix tools:
    /// http://stackoverflow.com/questions/2287967/why-is-it-recommended-to-have-empty-line-in-the-end-of-file
    public let linebreakAtEndOfFile: SwiftFormat.FormatRule

    /// Indent code according to standard scope indenting rules.
    /// The type (tab or space) and level (2 spaces, 4 spaces, etc.) of the
    /// indenting can be configured with the `options` parameter of the formatter.
    public let indent: SwiftFormat.FormatRule

    public let braces: SwiftFormat.FormatRule

    /// Ensure that an `else` statement following `if { ... }` appears on the same line
    /// as the closing brace. This has no effect on the `else` part of a `guard` statement.
    /// Also applies to `catch` after `try` and `while` after `repeat`.
    public let elseOnSameLine: SwiftFormat.FormatRule

    /// Ensure that the last item in a multi-line array literal is followed by a comma.
    /// This is useful for preventing noise in commits when items are added to end of array.
    public let trailingCommas: SwiftFormat.FormatRule

    /// Ensure that TODO, MARK and FIXME comments are followed by a : as required
    public let todos: SwiftFormat.FormatRule

    /// Remove semicolons, except where doing so would change the meaning of the code
    public let semicolons: SwiftFormat.FormatRule

    /// Standardise linebreak characters as whatever is specified in the options (\n by default)
    public let linebreaks: SwiftFormat.FormatRule

    /// Standardise the order of property specifiers
    public let specifiers: SwiftFormat.FormatRule

    /// Convert closure arguments to trailing closure syntax where possible
    /// NOTE: Parens around trailing closures are sometimes required for disambiguation.
    /// SwiftFormat can't detect those cases, so `trailingClosures` is disabled by default
    public let trailingClosures: SwiftFormat.FormatRule

    /// Remove redundant parens around the arguments for loops, if statements, closures, etc.
    public let redundantParens: SwiftFormat.FormatRule

    /// Remove redundant `get {}` clause inside read-only computed property
    public let redundantGet: SwiftFormat.FormatRule

    /// Remove redundant `= nil` initialization for Optional properties
    public let redundantNilInit: SwiftFormat.FormatRule

    /// Remove redundant let/var for unnamed variables
    public let redundantLet: SwiftFormat.FormatRule

    /// Remove redundant pattern in case statements
    public let redundantPattern: SwiftFormat.FormatRule

    /// Remove redundant raw string values for case statements
    public let redundantRawValues: SwiftFormat.FormatRule

    /// Remove redundant void return values for function declarations
    public let redundantVoidReturnType: SwiftFormat.FormatRule

    /// Remove redundant return keyword from single-line closures
    public let redundantReturn: SwiftFormat.FormatRule

    /// Remove redundant backticks around non-keywords, or in places where keywords don't need escaping
    public let redundantBackticks: SwiftFormat.FormatRule

    public let redundantSelf: SwiftFormat.FormatRule

    /// Replace unused arguments with an underscore
    public let unusedArguments: SwiftFormat.FormatRule

    /// Move `let` and `var` inside patterns to the beginning
    public let hoistPatternLet: SwiftFormat.FormatRule

    /// Normalize argument wrapping style
    public let wrapArguments: SwiftFormat.FormatRule

    /// Normalize the use of void in closure arguments and return values
    public let void: SwiftFormat.FormatRule

    /// Standardize formatting of numeric literals
    public let numberFormatting: SwiftFormat.FormatRule

    /// Strip header comments from the file
    public let fileHeader: SwiftFormat.FormatRule

    /// Strip redundant `.init` from type instantiations
    public let redundantInit: SwiftFormat.FormatRule

    /// Sort import statements
    public let sortedImports: SwiftFormat.FormatRule

    /// Remove duplicate import statements
    public let duplicateImports: SwiftFormat.FormatRule

    /// Strip unnecessary `weak` from @IBOutlet properties (except delegates and datasources)
    public let strongOutlets: SwiftFormat.FormatRule

    /// Remove white-space between empty braces
    public let emptyBraces: SwiftFormat.FormatRule

    /// Replace the `&&` operator with `,` where applicable
    public let andOperator: SwiftFormat.FormatRule

    /// Replace count == 0 with isEmpty
    public let isEmpty: SwiftFormat.FormatRule

    /// Remove redundant `let error` from `catch` statements
    public let redundantLetError: SwiftFormat.FormatRule

    /// Prefer `AnyObject` over `class` for class-based protocols
    public let anyObjectProtocol: SwiftFormat.FormatRule

    /// Remove redundant `break` keyword from switch cases
    public let redundantBreak: SwiftFormat.FormatRule

    /// Removed backticks from `self` when strongifying
    public let strongifiedSelf: SwiftFormat.FormatRule

    /// Remove redundant @objc annotation
    public let redundantObjc: SwiftFormat.FormatRule

    /// Replace Array<T>, Dictionary<T, U> and Optional<T> with [T], [T: U] and T?
    public let typeSugar: SwiftFormat.FormatRule

    /// Remove redundant access control level modifiers in extensions
    public let redundantExtensionACL: SwiftFormat.FormatRule

    /// Replace `fileprivate` with `private` where possible
    public let redundantFileprivate: SwiftFormat.FormatRule

    /// Reorders "yoda conditions" where constant is placed on lhs of a comparison
    public let yodaConditions: SwiftFormat.FormatRule

    public let leadingDelimiters: SwiftFormat.FormatRule
}

extension _FormatRules {
    /// A Dictionary of rules by name
    public var byName: [String: SwiftFormat.FormatRule] { get }

    /// All rules
    public var all: [SwiftFormat.FormatRule] { get }

    /// Default active rules
    public var `default`: [SwiftFormat.FormatRule] { get }

    /// Rules that are disabled by default
    public var disabledByDefault: [String] { get }

    /// Just the specified rules
    public func named(_ names: [String]) -> [SwiftFormat.FormatRule]

    /// All rules except those specified
    public func all(except rules: [String]) -> [SwiftFormat.FormatRule]

    @available(*, deprecated, message: "Use named() method instead")
    public func all(named: [String]) -> [SwiftFormat.FormatRule]
}

/// Apply specified rules to a token array with optional callback
/// Useful for perfoming additional logic after each rule is applied
public func applyRules(_ rules: [SwiftFormat.FormatRule], to originalTokens: [SwiftFormat.Token], with options: SwiftFormat.FormatOptions, callback: ((Int, [SwiftFormat.Token]) -> Void)? = nil) throws -> [SwiftFormat.Token]

/// Legacy file enumeration function
@available(*, deprecated, message: "Use other enumerateFiles() method instead")
public func enumerateFiles(withInputURL inputURL: URL, excluding excludedURLs: [URL] = [], outputURL: URL? = nil, options fileOptions: SwiftFormat.FileOptions = .default, concurrent: Bool = true, block: @escaping (URL, URL) throws -> () throws -> Void) -> [Error]

/// Enumerate all swift files at the specified location and (optionally) calculate an output file URL for each.
/// Ignores the file if any of the excluded file URLs is a prefix of the input file URL.
///
/// Files are enumerated concurrently. For convenience, the enumeration block returns a completion block, which
/// will be executed synchronously on the calling thread once enumeration is complete.
///
/// Errors may be thrown by either the enumeration block or the completion block, and are gathered into an
/// array and returned after enumeration is complete, along with any errors generated by the function itself.
/// Throwing an error from inside either block does *not* terminate the enumeration.
public func enumerateFiles(withInputURL inputURL: URL, outputURL: URL? = nil, options baseOptions: SwiftFormat.Options = .default, concurrent: Bool = true, skipped: SwiftFormat.FileEnumerationHandler? = nil, handler: @escaping SwiftFormat.FileEnumerationHandler) -> [Error]

/// Expand one or more comma-delimited file paths using glob syntax
public func expandGlobs(_ paths: String, in directory: String) -> [SwiftFormat.Glob]

public func expandPath(_ path: String, in directory: String) -> URL

/// Format a pre-parsed token array
/// Returns the formatted token array, and the number of edits made
public func format(_ tokens: [SwiftFormat.Token], rules: [SwiftFormat.FormatRule] = FormatRules.default, options: SwiftFormat.FormatOptions = .default) throws -> [SwiftFormat.Token]

/// Format code with specified rules and options
public func format(_ source: String, rules: [SwiftFormat.FormatRule] = FormatRules.default, options: SwiftFormat.FormatOptions = .default) throws -> String

/// Infer default options by examining the existing source
public func inferFormatOptions(from tokens: [SwiftFormat.Token]) -> SwiftFormat.FormatOptions

/// Get line/column offset for token
/// Note: line indexes start at 1, columns start at zero
public func offsetForToken(at index: Int, in tokens: [SwiftFormat.Token]) -> (line: Int, column: Int)

/// Process parsing errors
public func parsingError(for tokens: [SwiftFormat.Token], options: SwiftFormat.FormatOptions) -> SwiftFormat.FormatError?

/// Convert a token array back into a string
public func sourceCode(for tokens: [SwiftFormat.Token]) -> String

/// The standard SwiftFormat config file name
public let swiftFormatConfigurationFile: String

/// The standard Swift version file name
public let swiftVersionFile: String

public func tokenize(_ source: String) -> [SwiftFormat.Token]

/// The current SwiftFormat version
public let version: String

extension String {
    /// Is this string a reserved keyword in Swift?
    public var isSwiftKeyword: Bool { get }

    /// Is this string a keyword in some contexts?
    public var isContextualKeyword: Bool { get }
}

public var FormatRules: SwiftFormat._FormatRules

/// The current SwiftFormat version
public var version: String

/// The standard SwiftFormat config file name
public var swiftFormatConfigurationFile: String

/// The standard Swift version file name
public var swiftVersionFile: String
