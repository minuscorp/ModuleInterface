import CommonCrypto
import Darwin
import Dispatch
import Foundation
import SourceKittenFramework
import SwiftOnoneSupport
import Yams

public protocol ASTRule: SwiftLintFramework.Rule {
    associatedtype KindType: RawRepresentable

    func validate(file: SourceKittenFramework.File, kind: Self.KindType, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

extension ASTRule where Self.KindType.RawValue == String {
    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public enum AccessControlLevel: String, CustomStringConvertible {
    case `private`

    case `fileprivate`

    case `internal`

    case `public`

    case open

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

extension AccessControlLevel: Comparable {
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
    public static func < (lhs: SwiftLintFramework.AccessControlLevel, rhs: SwiftLintFramework.AccessControlLevel) -> Bool
}

public protocol AnalyzerRule: SwiftLintFramework.OptInRule {}

extension AnalyzerRule {
    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension AnalyzerRule where Self: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

/// Type-erased protocol used to check whether a rule is collectable.
public protocol AnyCollectingRule: SwiftLintFramework.Rule {}

public struct AnyObjectProtocolRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct ArrayInitRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct AttributesConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(alwaysOnSameLine: [String] = ["@IBAction", "@NSManaged"], alwaysInNewLine: [String] = [])

    public mutating func apply(configuration: Any) throws
}

public struct AttributesRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.AttributesConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public protocol AutomaticTestableRule: SwiftLintFramework.Rule {}

public struct BlockBasedKVORule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct CSVReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct CheckstyleReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct ClassDelegateProtocolRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ClosingBraceRule: SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct ClosureBodyLengthRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityLevelsConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ClosureEndIndentationRule: SwiftLintFramework.Rule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension ClosureEndIndentationRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct ClosureParameterPositionRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ClosureSpacingRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

/// Represents a file that can compute style violations and corrections for a list of rules.
///
/// A `CollectedLinter` is only created after a `Linter` has run its collection steps in `Linter.collect(into:)`.
public struct CollectedLinter {
    public let file: SourceKittenFramework.File

    public func styleViolations(using storage: SwiftLintFramework.RuleStorage) -> [SwiftLintFramework.StyleViolation]

    public func styleViolationsAndRuleTimes(using storage: SwiftLintFramework.RuleStorage) -> ([SwiftLintFramework.StyleViolation], [(id: String, time: Double)])

    public func correct(using storage: SwiftLintFramework.RuleStorage) -> [SwiftLintFramework.Correction]

    public func format(useTabs: Bool, indentWidth: Int)
}

public protocol CollectingCorrectableRule: SwiftLintFramework.CollectingRule, SwiftLintFramework.CorrectableRule {
    func correct(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo], compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    func correct(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo]) -> [SwiftLintFramework.Correction]
}

extension CollectingCorrectableRule {
    public func correct(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo], compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]
}

extension CollectingCorrectableRule where Self: SwiftLintFramework.AnalyzerRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo]) -> [SwiftLintFramework.Correction]
}

public protocol CollectingRule: SwiftLintFramework.AnyCollectingRule {
    associatedtype FileInfo

    func collectInfo(for file: SourceKittenFramework.File, compilerArguments: [String]) -> Self.FileInfo

    func collectInfo(for file: SourceKittenFramework.File) -> Self.FileInfo

    func validate(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo], compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    func validate(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo]) -> [SwiftLintFramework.StyleViolation]
}

extension CollectingRule {
    public func collectInfo(for file: SourceKittenFramework.File, into storage: SwiftLintFramework.RuleStorage, compilerArguments: [String])

    public func validate(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func collectInfo(for file: SourceKittenFramework.File, compilerArguments: [String]) -> Self.FileInfo

    public func validate(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo], compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]
}

extension CollectingRule where Self: SwiftLintFramework.AnalyzerRule {
    public func collectInfo(for file: SourceKittenFramework.File) -> Self.FileInfo

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: Self.FileInfo]) -> [SwiftLintFramework.StyleViolation]
}

public struct CollectionAlignmentConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct CollectionAlignmentRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.CollectionAlignmentConfiguration

    public init()

    public static var description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ColonConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ColonRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.ColonConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

extension ColonRule: SwiftLintFramework.ASTRule {
    /// Only returns dictionary and function calls colon violations
    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct CommaRule: SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public struct Command: Equatable {
    public enum Action: String {
        case enable

        case disable
    }

    public enum Modifier: String {
        case previous

        case this

        case next
    }

    public init(action: SwiftLintFramework.Command.Action, ruleIdentifiers: Set<SwiftLintFramework.RuleIdentifier>, line: Int = 0, character: Int? = nil, modifier: SwiftLintFramework.Command.Modifier? = nil, trailingComment: String? = nil)

    public init?(string: NSString, range: NSRange)
}

public struct CompilerProtocolInitRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ConditionalReturnsOnNewlineConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ConditionalReturnsOnNewlineRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.Rule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.ConditionalReturnsOnNewlineConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct Configuration: Hashable {
    public enum RulesMode {
        case `default`(disabled: [String], optIn: [String])

        case whitelisted([String])

        case allEnabled
    }

    public static let fileName: String

    public let indentation: SwiftLintFramework.Configuration.IndentationStyle

    public let included: [String]

    public let excluded: [String]

    public let reporter: String

    public let warningThreshold: Int?

    public private(set) var rootPath: String? {
        get
    }

    public private(set) var configurationPath: String? {
        get
    }

    public let cachePath: String?

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

    public let rules: [SwiftLintFramework.Rule]

    public init?(rulesMode: SwiftLintFramework.Configuration.RulesMode = .default(disabled: [], optIn: []), included: [String] = [], excluded: [String] = [], warningThreshold: Int? = nil, reporter: String = XcodeReporter.identifier, ruleList: SwiftLintFramework.RuleList = masterRuleList, configuredRules: [SwiftLintFramework.Rule]? = nil, swiftlintVersion: String? = nil, cachePath: String? = nil, indentation: SwiftLintFramework.Configuration.IndentationStyle = .default, customRulesIdentifiers: [String] = [])

    public init(path: String = Configuration.fileName, rootPath: String? = nil, optional: Bool = true, quiet: Bool = false, enableAllRules: Bool = false, cachePath: String? = nil, customRulesIdentifiers: [String] = [])

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftLintFramework.Configuration, rhs: SwiftLintFramework.Configuration) -> Bool
}

extension Configuration {
    public func withPrecomputedCacheDescription() -> SwiftLintFramework.Configuration
}

extension Configuration {
    public enum IndentationStyle: Equatable {
        case tabs

        case spaces(count: Int)

        public static var `default`: SwiftLintFramework.Configuration.IndentationStyle
    }
}

extension Configuration {
    public func lintableFiles(inPath path: String, forceExclude: Bool) -> [SourceKittenFramework.File]
}

extension Configuration {
    public func filterExcludedPaths(fileManager: SwiftLintFramework.LintableFileManager = FileManager.default, in paths: [String]...) -> [String]
}

extension Configuration {
    public func configuration(for file: SourceKittenFramework.File) -> SwiftLintFramework.Configuration
}

extension Configuration {
    public init?(dict: [String: Any], ruleList: SwiftLintFramework.RuleList = masterRuleList, enableAllRules: Bool = false, cachePath: String? = nil, customRulesIdentifiers: [String] = [])
}

public enum ConfigurationError: Error {
    case unknownConfiguration
}

public protocol ConfigurationProviderRule: SwiftLintFramework.Rule {
    associatedtype ConfigurationType: SwiftLintFramework.RuleConfiguration

    var configuration: Self.ConfigurationType { get set }
}

extension ConfigurationProviderRule {
    public init(configuration: Any) throws

    public func isEqualTo(_ rule: SwiftLintFramework.Rule) -> Bool

    public var configurationDescription: String { get }
}

extension ConfigurationProviderRule where Self.ConfigurationType == SwiftLintFramework.NameConfiguration {
    public func severity(forLength length: Int) -> SwiftLintFramework.ViolationSeverity?
}

public struct ContainsOverFilterCountRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ContainsOverFilterIsEmptyRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ContainsOverFirstNotNilRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ContainsOverRangeNilComparisonRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ControlStatementRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ConvenienceTypeRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public protocol CorrectableRule: SwiftLintFramework.Rule {
    func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]

    func correct(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.Correction]
}

extension CorrectableRule {
    public func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]

    public func correct(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.Correction]
}

public struct Correction: Equatable {
    public let ruleDescription: SwiftLintFramework.RuleDescription

    public let location: SwiftLintFramework.Location

    public var consoleDescription: String { get }
}

public struct CustomRules: SwiftLintFramework.Rule, SwiftLintFramework.ConfigurationProviderRule {
    public static let description: SwiftLintFramework.RuleDescription

    public var configuration: SwiftLintFramework.CustomRulesConfiguration

    public init()

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct CustomRulesConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public var customRuleConfigurations: [SwiftLintFramework.RegexConfiguration]

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct CyclomaticComplexityConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public static let defaultComplexityStatements: Set<SourceKittenFramework.StatementKind>

    public private(set) var length: SwiftLintFramework.SeverityLevelsConfiguration {
        get
    }

    public private(set) var complexityStatements: Set<SourceKittenFramework.StatementKind> {
        get
    }

    public private(set) var ignoresCaseStatements: Bool

    public init(warning: Int, error: Int?, ignoresCaseStatements: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct CyclomaticComplexityRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.CyclomaticComplexityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DeploymentTargetConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public struct Version: Equatable, Comparable {
        public let major: Int

        public let minor: Int

        public let patch: Int

        public var stringValue: String { get }

        public init(major: Int, minor: Int = 0, patch: Int = 0)

        public init(rawValue: String) throws

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
        public static func < (lhs: SwiftLintFramework.DeploymentTargetConfiguration.Version, rhs: SwiftLintFramework.DeploymentTargetConfiguration.Version) -> Bool
    }

    public var consoleDescription: String { get }

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct DeploymentTargetRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.DeploymentTargetConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct DiscardedNotificationCenterObserverRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DiscouragedDirectInitConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var severityConfiguration: SwiftLintFramework.SeverityConfiguration

    public var consoleDescription: String { get }

    public var severity: SwiftLintFramework.ViolationSeverity { get }

    public private(set) var discouragedInits: Set<String> {
        get
    }

    public mutating func apply(configuration: Any) throws
}

public struct DiscouragedDirectInitRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.DiscouragedDirectInitConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DiscouragedObjectLiteralRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.ObjectLiteralConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DiscouragedOptionalBooleanRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct DiscouragedOptionalCollectionRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DuplicateEnumCasesRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.ASTRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct DuplicateImportsRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct DynamicInlineRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct EmojiReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct EmptyCollectionLiteralRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct EmptyCountRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct EmptyEnumArgumentsRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct EmptyParametersRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct EmptyParenthesesWithTrailingClosureRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct EmptyStringRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct EmptyXCTestMethodRule: SwiftLintFramework.Rule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ExplicitACLRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ExplicitEnumRawValueRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ExplicitInitRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct ExplicitSelfRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AnalyzerRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]
}

public struct ExplicitTopLevelACLRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ExplicitTypeInterfaceConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct ExplicitTypeInterfaceRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.ExplicitTypeInterfaceConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ExtensionAccessModifierRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct FallthroughRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FatalErrorMessageRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct FileHeaderConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct FileHeaderRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.FileHeaderConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FileLengthRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.FileLengthRuleConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FileLengthRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(warning: Int, error: Int?, ignoreCommentOnlyLines: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct FileNameConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public private(set) var severity: SwiftLintFramework.SeverityConfiguration {
        get
    }

    public private(set) var excluded: Set<String> {
        get
    }

    public private(set) var prefixPattern: String {
        get
    }

    public private(set) var suffixPattern: String {
        get
    }

    public private(set) var nestedTypeSeparator: String {
        get
    }

    public init(severity: SwiftLintFramework.ViolationSeverity, excluded: [String] = [], prefixPattern: String = "", suffixPattern: String = "\\+.*", nestedTypeSeparator: String = ".")

    public mutating func apply(configuration: Any) throws
}

public struct FileNameRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.FileNameConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FileTypesOrderConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct FileTypesOrderRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.FileTypesOrderConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FirstWhereRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FlatMapOverMapReduceRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ForWhereRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ForceCastRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ForceTryRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ForceUnwrappingRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct FunctionBodyLengthRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityLevelsConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct FunctionDefaultParameterAtEndRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct FunctionParameterCountConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(warning: Int, error: Int?, ignoresDefaultParameters: Bool = true)

    public mutating func apply(configuration: Any) throws
}

public struct FunctionParameterCountRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.FunctionParameterCountConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct GenericTypeNameRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.NameConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct HTMLReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct IdenticalOperandsRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct IdentifierNameRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.NameConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ImplicitGetterRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ImplicitReturnRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public struct ImplicitlyUnwrappedOptionalConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public enum ImplicitlyUnwrappedOptionalModeConfiguration: String {
    case all

    case allExceptIBOutlets
}

public struct ImplicitlyUnwrappedOptionalRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.ImplicitlyUnwrappedOptionalConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct InertDeferRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct IsDisjointRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct JSONReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct JUnitReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct JoinedDefaultParameterRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct LargeTupleRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityLevelsConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct LastWhereRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct LeadingWhitespaceRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SourceKitFreeRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct LegacyCGGeometryFunctionsRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct LegacyConstantRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct LegacyConstructorRule: SwiftLintFramework.ASTRule, SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct LegacyHashingRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct LegacyMultipleRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct LegacyNSGeometryFunctionsRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct LegacyRandomRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static var description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct LetVarWhitespaceRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct LineLengthConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(warning: Int, error: Int?, options: SwiftLintFramework.LineLengthRuleOptions = [])

    public mutating func apply(configuration: Any) throws
}

public struct LineLengthRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.LineLengthConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct LineLengthRuleOptions: OptionSet {
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
    public let rawValue: Int

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: Int = 0)

    public static let ignoreURLs: SwiftLintFramework.LineLengthRuleOptions

    public static let ignoreFunctionDeclarations: SwiftLintFramework.LineLengthRuleOptions

    public static let ignoreComments: SwiftLintFramework.LineLengthRuleOptions

    public static let ignoreInterpolatedStrings: SwiftLintFramework.LineLengthRuleOptions

    public static let all: SwiftLintFramework.LineLengthRuleOptions
}

public protocol LintableFileManager {
    func filesToLint(inPath: String, rootDirectory: String?) -> [String]

    func modificationDate(forFileAtPath: String) -> Date?
}

/// Represents a file that can be linted for style violations and corrections after being collected.
public struct Linter {
    public let file: SourceKittenFramework.File

    public var isCollecting: Bool

    public init(file: SourceKittenFramework.File, configuration: SwiftLintFramework.Configuration = Configuration()!, cache: SwiftLintFramework.LinterCache? = nil, compilerArguments: [String] = [])

    /// Returns a linter capable of checking for violations after running each rule's collection step.
    public func collect(into storage: SwiftLintFramework.RuleStorage) -> SwiftLintFramework.CollectedLinter
}

public final class LinterCache {
    public init(configuration: SwiftLintFramework.Configuration, fileManager: SwiftLintFramework.LintableFileManager = FileManager.default)

    public func save() throws
}

public struct LiteralExpressionEndIdentationRule: SwiftLintFramework.Rule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension LiteralExpressionEndIdentationRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct Location: CustomStringConvertible, Comparable, Codable {
    public let file: String?

    public let line: Int?

    public let character: Int?

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

    public var relativeFile: String? { get }

    public init(file: String?, line: Int? = nil, character: Int? = nil)

    public init(file: SourceKittenFramework.File, byteOffset offset: Int)

    public init(file: SourceKittenFramework.File, characterOffset offset: Int)

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
    public static func < (lhs: SwiftLintFramework.Location, rhs: SwiftLintFramework.Location) -> Bool
}

public struct LowerACLThanParentRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct MarkRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct MarkdownReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct MissingDocsRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public init()

    public typealias ConfigurationType = SwiftLintFramework.MissingDocsRuleConfiguration

    public var configuration: SwiftLintFramework.MissingDocsRuleConfiguration

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct MissingDocsRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ModifierOrderConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(preferredModifierOrder: [SourceKittenFramework.SwiftDeclarationAttributeKind.ModifierGroup] = [])

    public mutating func apply(configuration: Any) throws
}

public struct ModifierOrderRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.CorrectableRule {
    public var configuration: SwiftLintFramework.ModifierOrderConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct MultilineArgumentsBracketsRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct MultilineArgumentsConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public enum FirstArgumentLocation: String {
        case anyLine

        case sameLine

        case nextLine
    }

    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct MultilineArgumentsRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.MultilineArgumentsConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct MultilineFunctionChainsRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct MultilineLiteralBracketsRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct MultilineParametersBracketsRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct MultilineParametersRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct MultipleClosuresWithTrailingClosureRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NSLocalizedStringKeyRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NSLocalizedStringRequireBundleRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NSObjectPreferIsEqualRule: SwiftLintFramework.Rule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct NameConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(minLengthWarning: Int, minLengthError: Int, maxLengthWarning: Int, maxLengthError: Int, excluded: [String] = [], allowedSymbols: [String] = [], validatesStartWithLowercase: Bool = true)

    public mutating func apply(configuration: Any) throws
}

public struct NestingConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(typeLevelWarning: Int, typeLevelError: Int?, statementLevelWarning: Int, statementLevelError: Int?)

    public mutating func apply(configuration: Any) throws
}

public struct NestingRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.NestingConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NimbleOperatorRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.CorrectableRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct NoExtensionAccessModifierRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NoFallthroughOnlyRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NoGroupingExtensionRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct NoSpaceInMethodCallRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct NotificationCenterDetachmentRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct NumberSeparatorConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(minimumLength: Int, minimumFractionLength: Int?, excludeRanges: [Range<Double>])

    public mutating func apply(configuration: Any) throws
}

public struct NumberSeparatorRule: SwiftLintFramework.OptInRule, SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.NumberSeparatorConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct ObjectLiteralConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ObjectLiteralRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.ObjectLiteralConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct OpeningBraceRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct OperatorFunctionWhitespaceRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct OperatorUsageWhitespaceRule: SwiftLintFramework.OptInRule, SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public protocol OptInRule: SwiftLintFramework.Rule {}

public struct OverriddenSuperCallRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.OverridenSuperCallConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct OverrideInExtensionRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct OverridenSuperCallConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public private(set) var resolvedMethodNames: [String] {
        get
    }

    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws

    public var severity: SwiftLintFramework.ViolationSeverity { get }
}

public struct PatternMatchingKeywordsRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct PrefixedConstantRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(onlyPrivateMembers: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct PrefixedTopLevelConstantRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.PrefixedConstantRuleConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct PrivateActionRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct PrivateOutletRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.PrivateOutletRuleConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct PrivateOutletRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(allowPrivateSet: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct PrivateOverFilePrivateRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableRule {
    public var configuration: SwiftLintFramework.PrivateOverFilePrivateRuleConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct PrivateOverFilePrivateRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var severityConfiguration: SwiftLintFramework.SeverityConfiguration

    public var validateExtensions: Bool

    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct PrivateUnitTestConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public let identifier: String

    public var name: String?

    public var message: String

    public var regex: NSRegularExpression!

    public var included: NSRegularExpression?

    public var severityConfiguration: SwiftLintFramework.SeverityConfiguration

    public var severity: SwiftLintFramework.ViolationSeverity { get }

    public var consoleDescription: String { get }

    public init(identifier: String)

    public mutating func apply(configuration: Any) throws
}

public struct PrivateUnitTestRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.PrivateUnitTestConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ProhibitedInterfaceBuilderRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ProhibitedSuperConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws

    public var severity: SwiftLintFramework.ViolationSeverity { get }
}

public struct ProhibitedSuperRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.ProhibitedSuperConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct ProtocolPropertyAccessorsOrderRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct QuickDiscouragedCallRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct QuickDiscouragedFocusedTestRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct QuickDiscouragedPendingTestRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ReduceBooleanRule: SwiftLintFramework.Rule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ReduceIntoRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static var description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct RedundantDiscardableLetRule: SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public struct RedundantNilCoalescingRule: SwiftLintFramework.OptInRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public struct RedundantObjcAttributeRule: SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

extension RedundantObjcAttributeRule {
    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct RedundantOptionalInitializationRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct RedundantSetAccessControlRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct RedundantStringEnumValueRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct RedundantTypeAnnotationRule: SwiftLintFramework.OptInRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public struct RedundantVoidReturnRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct RegexConfiguration: SwiftLintFramework.RuleConfiguration, Hashable {
    public let identifier: String

    public var name: String?

    public var message: String

    public var regex: NSRegularExpression!

    public var included: NSRegularExpression?

    public var excluded: NSRegularExpression?

    public var matchKinds: Set<SourceKittenFramework.SyntaxKind>

    public var severityConfiguration: SwiftLintFramework.SeverityConfiguration

    public var severity: SwiftLintFramework.ViolationSeverity { get }

    public var consoleDescription: String { get }

    public var description: SwiftLintFramework.RuleDescription { get }

    public init(identifier: String)

    public mutating func apply(configuration: Any) throws

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

public struct Region: Equatable {
    public let start: SwiftLintFramework.Location

    public let end: SwiftLintFramework.Location

    public let disabledRuleIdentifiers: Set<SwiftLintFramework.RuleIdentifier>

    public init(start: SwiftLintFramework.Location, end: SwiftLintFramework.Location, disabledRuleIdentifiers: Set<SwiftLintFramework.RuleIdentifier>)

    public func contains(_ location: SwiftLintFramework.Location) -> Bool

    public func isRuleEnabled(_ rule: SwiftLintFramework.Rule) -> Bool

    public func isRuleDisabled(_ rule: SwiftLintFramework.Rule) -> Bool

    public func deprecatedAliasesDisabling(rule: SwiftLintFramework.Rule) -> Set<String>
}

public protocol Reporter: CustomStringConvertible {
    static var identifier: String { get }

    static var isRealtime: Bool { get }

    static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

/// Rule to require all classes to have a deinit method
///
/// An example of when this is useful is if the project does allocation tracking
/// of objects and the deinit should print a message or remove its instance from a
/// list of allocations. Even having an empty deinit method is useful to provide
/// a place to put a breakpoint when chasing down leaks.
public struct RequiredDeinitRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public static let description: SwiftLintFramework.RuleDescription

    public init()

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

/// Allows for Enums that conform to a protocol to require that a specific case be present.
///
/// This is primarily for result enums where a specific case is common but cannot be inherited due to cases not being
/// inheritable.
///
/// For example: A result enum is used to define all of the responses a client must handle from a specific service call
/// in an API.
///
/// ````
/// enum MyServiceCallResponse: String {
///     case unauthorized
///     case unknownError
///     case accountCreated
/// }
///
/// // An exhaustive switch can be used so any new scenarios added cause compile errors.
/// switch response {
///    case unauthorized:
///        ...
///    case unknownError:
///        ...
///    case accountCreated:
///        ...
/// }
/// ````
///
/// If cases could be inherited you could put all of the common ones in an enum and then inherit from that enum:
///
/// ````
/// enum MyServiceResponse: String {
///     case unauthorized
///     case unknownError
/// }
///
/// enum MyServiceCallResponse: MyServiceResponse {
///     case accountCreated
/// }
/// ````
///
/// Which would result in MyServiceCallResponse having all of the cases when compiled:
///
/// ```
/// enum MyServiceCallResponse: MyServiceResponse {
///     case unauthorized
///     case unknownError
///     case accountCreated
/// }
/// ```
///
/// Since that cannot be done this rule allows you to define cases that should be present if conforming to a protocol.
///
/// `.swiftlint.yml`
/// ````
/// required_enum_case:
///   MyServiceResponse:
///     unauthorized: error
///     unknownError: error
/// ````
///
/// ````
/// protocol MyServiceResponse {}
///
/// // This will now have errors because `unauthorized` and `unknownError` are not present.
/// enum MyServiceCallResponse: String, MyServiceResponse {
///     case accountCreated
/// }
/// ````
public struct RequiredEnumCaseRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.RequiredEnumCaseRuleConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct RequiredEnumCaseRuleConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ReturnArrowWhitespaceRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public protocol Rule {
    static var description: SwiftLintFramework.RuleDescription { get }

    var configurationDescription: String { get }

    init()

    init(configuration: Any) throws

    func validate(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    func isEqualTo(_ rule: SwiftLintFramework.Rule) -> Bool

    func collectInfo(for file: SourceKittenFramework.File, into storage: SwiftLintFramework.RuleStorage, compilerArguments: [String])

    func validate(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]
}

extension Rule {
    public func validate(file: SourceKittenFramework.File, using storage: SwiftLintFramework.RuleStorage, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func isEqualTo(_ rule: SwiftLintFramework.Rule) -> Bool

    public func collectInfo(for file: SourceKittenFramework.File, into storage: SwiftLintFramework.RuleStorage, compilerArguments: [String])
}

public protocol RuleConfiguration {
    var consoleDescription: String { get }

    mutating func apply(configuration: Any) throws

    func isEqualTo(_ ruleConfiguration: SwiftLintFramework.RuleConfiguration) -> Bool
}

extension RuleConfiguration where Self: Equatable {
    public func isEqualTo(_ ruleConfiguration: SwiftLintFramework.RuleConfiguration) -> Bool
}

public struct RuleDescription: Equatable, Codable {
    public let identifier: String

    public let name: String

    public let description: String

    public let kind: SwiftLintFramework.RuleKind

    public let nonTriggeringExamples: [String]

    public let triggeringExamples: [String]

    public let corrections: [String: String]

    public let deprecatedAliases: Set<String>

    public let minSwiftVersion: SwiftLintFramework.SwiftVersion

    public let requiresFileOnDisk: Bool

    public var consoleDescription: String { get }

    public var allIdentifiers: [String] { get }

    public init(identifier: String, name: String, description: String, kind: SwiftLintFramework.RuleKind, minSwiftVersion: SwiftLintFramework.SwiftVersion = .three, nonTriggeringExamples: [String] = [], triggeringExamples: [String] = [], corrections: [String: String] = [:], deprecatedAliases: Set<String> = [], requiresFileOnDisk: Bool = false)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: SwiftLintFramework.RuleDescription, rhs: SwiftLintFramework.RuleDescription) -> Bool
}

public enum RuleIdentifier: Hashable, ExpressibleByStringLiteral {
    case all

    case single(identifier: String)

    public var stringRepresentation: String { get }

    public init(_ value: String)

    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String)
}

public enum RuleKind: String, Codable {
    case lint

    case idiomatic

    case style

    case metrics

    case performance
}

public struct RuleList {
    public let list: [String: SwiftLintFramework.Rule.Type]

    public init(rules: SwiftLintFramework.Rule.Type...)

    public init(rules: [SwiftLintFramework.Rule.Type])
}

extension RuleList {
    public func generateDocumentation() -> String
}

public enum RuleListError: Error {
    case duplicatedConfigurations(rule: SwiftLintFramework.Rule.Type)
}

public struct RuleParameter<T>: Equatable where T: Equatable {
    public let severity: SwiftLintFramework.ViolationSeverity

    public let value: T

    public init(severity: SwiftLintFramework.ViolationSeverity, value: T)
}

public class RuleStorage {
    public init()
}

public struct SeverityConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(_ severity: SwiftLintFramework.ViolationSeverity)

    public mutating func apply(configuration: Any) throws
}

public struct SeverityLevelsConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public var shortConsoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct ShorthandOperatorRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct SingleTestClassRule: SwiftLintFramework.Rule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public static let description: SwiftLintFramework.RuleDescription

    public init()

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct SonarQubeReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct SortedFirstLastRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct SortedImportsRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public protocol SourceKitFreeRule: SwiftLintFramework.Rule {}

public struct StatementConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(statementMode: SwiftLintFramework.StatementModeConfiguration, severity: SwiftLintFramework.SeverityConfiguration)

    public mutating func apply(configuration: Any) throws
}

public enum StatementModeConfiguration: String {
    case `default`

    case uncuddledElse
}

public struct StatementPositionRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.StatementConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public static let uncuddledDescription: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct StaticOperatorRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct StrictFilePrivateRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct StrongIBOutletRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct StyleViolation: CustomStringConvertible, Equatable, Codable {
    public let ruleDescription: SwiftLintFramework.RuleDescription

    public let severity: SwiftLintFramework.ViolationSeverity

    public let location: SwiftLintFramework.Location

    public let reason: String

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

    public init(ruleDescription: SwiftLintFramework.RuleDescription, severity: SwiftLintFramework.ViolationSeverity = .warning, location: SwiftLintFramework.Location, reason: String? = nil)
}

public protocol SubstitutionCorrectableASTRule: SwiftLintFramework.ASTRule, SwiftLintFramework.SubstitutionCorrectableRule {
    func violationRanges(in file: SourceKittenFramework.File, kind: Self.KindType, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

extension SubstitutionCorrectableASTRule where Self.KindType.RawValue == String {
    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]
}

public protocol SubstitutionCorrectableRule: SwiftLintFramework.CorrectableRule {
    func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

extension SubstitutionCorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct SuperfluousDisableCommandRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func reason(for rule: SwiftLintFramework.Rule.Type) -> String

    public func reason(for rule: String) -> String

    public func reason(forNonExistentRule rule: String) -> String
}

public enum SwiftExpressionKind: String {
    case call

    case argument

    case array

    case dictionary

    case objectLiteral

    case closure

    case tuple
}

public struct SwiftVersion: RawRepresentable, Codable {
    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = String

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
    public init(rawValue: String)
}

extension SwiftVersion: Comparable {
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
    public static func < (lhs: SwiftLintFramework.SwiftVersion, rhs: SwiftLintFramework.SwiftVersion) -> Bool
}

extension SwiftVersion {
    public static let three: SwiftLintFramework.SwiftVersion

    public static let four: SwiftLintFramework.SwiftVersion

    public static let fourDotOne: SwiftLintFramework.SwiftVersion

    public static let fourDotTwo: SwiftLintFramework.SwiftVersion

    public static let five: SwiftLintFramework.SwiftVersion

    public static let fiveDotOne: SwiftLintFramework.SwiftVersion

    public static let current: SwiftLintFramework.SwiftVersion
}

public struct SwitchCaseAlignmentConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct SwitchCaseAlignmentRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SwitchCaseAlignmentConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct SwitchCaseOnNewlineRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct SyntacticSugarRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct TodoRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ToggleBoolRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static var description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct TrailingClosureConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(onlySingleMutedParameter: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct TrailingClosureRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.TrailingClosureConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct TrailingCommaConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(mandatoryComma: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct TrailingCommaRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.TrailingCommaConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct TrailingNewlineRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SourceKitFreeRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct TrailingSemicolonRule: SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct TrailingWhitespaceConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(ignoresEmptyLines: Bool, ignoresComments: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct TrailingWhitespaceRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.TrailingWhitespaceConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct TypeBodyLengthRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityLevelsConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct TypeContentsOrderConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public mutating func apply(configuration: Any) throws
}

public struct TypeContentsOrderRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule {
    public var configuration: SwiftLintFramework.TypeContentsOrderConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct TypeNameRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.NameConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnavailableFunctionRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnneededBreakInSwitchRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct UnneededParenthesesInClosureArgumentRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.CorrectableRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct UnownedVariableCaptureRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UntypedErrorInCatchRule: SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension UntypedErrorInCatchRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct UnusedCaptureListRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static var description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnusedClosureParameterRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct UnusedControlFlowLabelRule: SwiftLintFramework.SubstitutionCorrectableASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)

    public func violationRanges(in file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [NSRange]
}

public struct UnusedDeclarationConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(severity: SwiftLintFramework.ViolationSeverity, includePublicAndOpen: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct UnusedDeclarationRule: SwiftLintFramework.AutomaticTestableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AnalyzerRule, SwiftLintFramework.CollectingRule {
    public struct FileUSRs {}

    public typealias FileInfo = SwiftLintFramework.UnusedDeclarationRule.FileUSRs

    public var configuration: SwiftLintFramework.UnusedDeclarationConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func collectInfo(for file: SourceKittenFramework.File, compilerArguments: [String]) -> SwiftLintFramework.UnusedDeclarationRule.FileUSRs

    public func validate(file: SourceKittenFramework.File, collectedInfo: [SourceKittenFramework.File: SwiftLintFramework.UnusedDeclarationRule.FileUSRs], compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnusedEnumeratedRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnusedImportRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AnalyzerRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File, compilerArguments: [String]) -> [SwiftLintFramework.Correction]
}

public struct UnusedOptionalBindingConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(ignoreOptionalTry: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct UnusedOptionalBindingRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.UnusedOptionalBindingConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct UnusedSetterValueRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

public struct ValidIBInspectableRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct Version {
    public let value: String

    public static let current: SwiftLintFramework.Version
}

public struct VerticalParameterAlignmentOnCallRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct VerticalParameterAlignmentRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct VerticalWhitespaceBetweenCasesRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()
}

extension VerticalWhitespaceBetweenCasesRule: SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension VerticalWhitespaceBetweenCasesRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct VerticalWhitespaceClosingBracesRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()
}

extension VerticalWhitespaceClosingBracesRule: SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configurationDescription: String { get }

    public init(configuration: Any) throws

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension VerticalWhitespaceClosingBracesRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct VerticalWhitespaceConfiguration: SwiftLintFramework.RuleConfiguration, Equatable {
    public var consoleDescription: String { get }

    public init(maxEmptyLines: Int)

    public mutating func apply(configuration: Any) throws
}

public struct VerticalWhitespaceOpeningBracesRule: SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()
}

extension VerticalWhitespaceOpeningBracesRule: SwiftLintFramework.OptInRule, SwiftLintFramework.AutomaticTestableRule {
    public var configurationDescription: String { get }

    public init(configuration: Any) throws

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]
}

extension VerticalWhitespaceOpeningBracesRule: SwiftLintFramework.CorrectableRule {
    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public struct VerticalWhitespaceRule: SwiftLintFramework.CorrectableRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.VerticalWhitespaceConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func correct(file: SourceKittenFramework.File) -> [SwiftLintFramework.Correction]
}

public enum ViolationSeverity: String, Comparable, Codable {
    case warning

    case error

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
    public static func < (lhs: SwiftLintFramework.ViolationSeverity, rhs: SwiftLintFramework.ViolationSeverity) -> Bool
}

public struct VoidReturnRule: SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.SubstitutionCorrectableRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File) -> [SwiftLintFramework.StyleViolation]

    public func violationRanges(in file: SourceKittenFramework.File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: SourceKittenFramework.File) -> (NSRange, String)
}

public struct WeakDelegateRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.SwiftDeclarationKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct XCTFailMessageRule: SwiftLintFramework.ASTRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct XCTSpecificMatcherRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SwiftLintFramework.SwiftExpressionKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public struct XcodeReporter: SwiftLintFramework.Reporter {
    public static let identifier: String

    public static let isRealtime: Bool

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

    public static func generateReport(_ violations: [SwiftLintFramework.StyleViolation]) -> String
}

public struct YamlParser {
    public static func parse(_ yaml: String, env: [String: String] = ProcessInfo.processInfo.environment) throws -> [String: Any]
}

public struct YodaConditionRule: SwiftLintFramework.ASTRule, SwiftLintFramework.OptInRule, SwiftLintFramework.ConfigurationProviderRule, SwiftLintFramework.AutomaticTestableRule {
    public var configuration: SwiftLintFramework.SeverityConfiguration

    public init()

    public static let description: SwiftLintFramework.RuleDescription

    public func validate(file: SourceKittenFramework.File, kind: SourceKittenFramework.StatementKind, dictionary: [String: SourceKittenFramework.SourceKitRepresentable]) -> [SwiftLintFramework.StyleViolation]
}

public let masterRuleList: SwiftLintFramework.RuleList

/**
 A thread-safe, newline-terminated version of fatalError that doesn't leak
 the source path from the compiled binary.
 */
public func queuedFatalError(_ string: String, file: StaticString = #file, line: UInt = #line) -> Never

/**
 A thread-safe version of Swift's standard print().

 - parameter object: Object to print.
 */
public func queuedPrint<T>(_ object: T)

/**
 A thread-safe, newline-terminated version of fputs(..., stderr).

 - parameter string: String to print.
 */
public func queuedPrintError(_ string: String)

public func reporterFrom(identifier: String) -> SwiftLintFramework.Reporter.Type

extension File {
    public func invalidateCache()
}

extension FileManager: SwiftLintFramework.LintableFileManager {
    public func filesToLint(inPath path: String, rootDirectory: String? = nil) -> [String]

    public func modificationDate(forFileAtPath path: String) -> Date?
}

extension NSRegularExpression.Options: Hashable {
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

extension String {
    public func absolutePathStandardized() -> String
}

extension SwiftDeclarationAttributeKind {
    public enum ModifierGroup: String, CustomDebugStringConvertible {
        case override

        case acl

        case setterACL

        case owned

        case mutators

        case final

        case typeMethods

        case required

        case convenience

        case lazy

        case dynamic

        case atPrefixed

        /// A textual representation of this instance, suitable for debugging.
        ///
        /// Calling this property directly is discouraged. Instead, convert an
        /// instance of any type to a string by using the `String(reflecting:)`
        /// initializer. This initializer works with any type, and uses the custom
        /// `debugDescription` property for types that conform to
        /// `CustomDebugStringConvertible`:
        ///
        ///     struct Point: CustomDebugStringConvertible {
        ///         let x: Int, y: Int
        ///
        ///         var debugDescription: String {
        ///             return "(\(x), \(y))"
        ///         }
        ///     }
        ///
        ///     let p = Point(x: 21, y: 30)
        ///     let s = String(reflecting: p)
        ///     print(s)
        ///     // Prints "(21, 30)"
        ///
        /// The conversion of `p` to a string in the assignment to `s` uses the
        /// `Point` type's `debugDescription` property.
        public var debugDescription: String { get }
    }
}

extension Array where Element == SwiftLintFramework.Rule {
    public static func == (lhs: [Element], rhs: [Element]) -> Bool
}

extension SyntaxKind {
    /// Returns if the syntax kind is comment-like.
    public var isCommentLike: Bool { get }
}

public var masterRuleList: SwiftLintFramework.RuleList
