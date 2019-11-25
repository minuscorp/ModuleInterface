

public extension Configuration {
    enum IndentationStyle: Equatable {
        public static var `default` = spaces(count: 4)
    }
}

public protocol LintableFileManager {
    func filesToLint(inPath: String, rootDirectory: String?) -> [String]

    func modificationDate(forFileAtPath: String) -> Date?
}

/// A thread-safe version of Swift's standard print().
/// - parameter object: Object to print.
public func queuedPrint<T>(_ object: T)

/// A thread-safe, newline-terminated version of fputs(..., stderr).
/// - parameter string: String to print.
public func queuedPrintError(_ string: String)

/// A thread-safe, newline-terminated version of fatalError that doesn't leak
/// the source path from the compiled binary.
public func queuedFatalError(_ string: String, file: StaticString = #file, line: UInt = #line) -> Never

public extension SwiftDeclarationAttributeKind {
    enum ModifierGroup: String, CustomDebugStringConvertible {
        public var debugDescription: String
    }
}

public enum SwiftExpressionKind: String {}

public enum AccessControlLevel: String, CustomStringConvertible {
    public var description: String
}

public struct Command: Equatable {
    public enum Action: String {}

    public enum Modifier: String {}

    public init(action: Action, ruleIdentifiers: Set<RuleIdentifier>, line: Int = 0,
                character: Int? = nil, modifier: Modifier? = nil, trailingComment: String? = nil)

    public init?(string: NSString, range: NSRange)
}

public struct Configuration: Hashable {
    public enum RulesMode {}

    public static let fileName = ".swiftlint.yml"

    public let indentation: IndentationStyle // style to use when indenting

    public let included: [String] // included

    public let excluded: [String] // excluded

    public let reporter: String // reporter (xcode, json, csv, checkstyle)

    public let warningThreshold: Int? // warning threshold

    public private(set) var rootPath: String? // the root path to search for nested configurations

    public private(set) var configurationPath: String? // if successfully loaded from a path

    public let cachePath: String?

    public func hash(into hasher: inout Hasher)

    public let rules: [Rule]

    public init?(rulesMode: RulesMode = .default(disabled: [], optIn: []),
                 included: [String] = [],
                 excluded: [String] = [],
                 warningThreshold: Int? = nil,
                 reporter: String = XcodeReporter.identifier,
                 ruleList: RuleList = masterRuleList,
                 configuredRules: [Rule]? = nil,
                 swiftlintVersion: String? = nil,
                 cachePath: String? = nil,
                 indentation: IndentationStyle = .default,
                 customRulesIdentifiers: [String] = [])

    public init(path: String = Configuration.fileName, rootPath: String? = nil,
                optional: Bool = true, quiet: Bool = false, enableAllRules: Bool = false,
                cachePath: String? = nil, customRulesIdentifiers: [String] = [])

    public static func == (lhs: Configuration, rhs: Configuration) -> Bool
}

public enum ConfigurationError: Error {}

public struct Correction: Equatable {
    public let ruleDescription: RuleDescription

    public let location: Location

    public var consoleDescription: String
}

/// Represents a file that can be linted for style violations and corrections after being collected.
public struct Linter {
    public let file: File

    public var isCollecting: Bool

    public init(file: File, configuration: Configuration = Configuration()!, cache: LinterCache? = nil,
                compilerArguments: [String] = [])

    /// Returns a linter capable of checking for violations after running each rule's collection step.
    public func collect(into storage: RuleStorage) -> CollectedLinter
}

/// Represents a file that can compute style violations and corrections for a list of rules.
/// A `CollectedLinter` is only created after a `Linter` has run its collection steps in `Linter.collect(into:)`.
public struct CollectedLinter {
    public let file: File

    public func styleViolations(using storage: RuleStorage) -> [StyleViolation]

    public func styleViolationsAndRuleTimes(using storage: RuleStorage)
        -> ([StyleViolation], [(id: String, time: Double)])

    public func correct(using storage: RuleStorage) -> [Correction]

    public func format(useTabs: Bool, indentWidth: Int)
}

public final class LinterCache {
    public init(configuration: Configuration, fileManager: LintableFileManager = FileManager.default)

    public func save() throws
}

public struct Location: CustomStringConvertible, Comparable, Codable {
    public let file: String?

    public let line: Int?

    public let character: Int?

    public var description: String

    public var relativeFile: String?

    public init(file: String?, line: Int? = nil, character: Int? = nil)

    public init(file: File, byteOffset offset: Int)

    public init(file: File, characterOffset offset: Int)

    public static func < (lhs: Location, rhs: Location) -> Bool
}

public struct Region: Equatable {
    public let start: Location

    public let end: Location

    public let disabledRuleIdentifiers: Set<RuleIdentifier>

    public init(start: Location, end: Location, disabledRuleIdentifiers: Set<RuleIdentifier>)

    public func contains(_ location: Location) -> Bool

    public func isRuleEnabled(_ rule: Rule) -> Bool

    public func isRuleDisabled(_ rule: Rule) -> Bool

    public func deprecatedAliasesDisabling(rule: Rule) -> Set<String>
}

public struct RuleDescription: Equatable, Codable {
    public let identifier: String

    public let name: String

    public let description: String

    public let kind: RuleKind

    public let nonTriggeringExamples: [String]

    public let triggeringExamples: [String]

    public let corrections: [String: String]

    public let deprecatedAliases: Set<String>

    public let minSwiftVersion: SwiftVersion

    public let requiresFileOnDisk: Bool

    public var consoleDescription: String

    public var allIdentifiers: [String]

    public init(identifier: String, name: String, description: String, kind: RuleKind,
                minSwiftVersion: SwiftVersion = .three,
                nonTriggeringExamples: [String] = [], triggeringExamples: [String] = [],
                corrections: [String: String] = [:],
                deprecatedAliases: Set<String> = [],
                requiresFileOnDisk: Bool = false)

    public static func == (lhs: RuleDescription, rhs: RuleDescription) -> Bool
}

public enum RuleIdentifier: Hashable, ExpressibleByStringLiteral {
    public var stringRepresentation: String

    public init(_ value: String)

    public init(stringLiteral value: String)
}

public enum RuleKind: String, Codable {}

public enum RuleListError: Error {}

public struct RuleList {
    public let list: [String: Rule.Type]

    public init(rules: Rule.Type...)

    public init(rules: [Rule.Type])
}

public struct RuleParameter<T: Equatable>: Equatable {
    public let severity: ViolationSeverity

    public let value: T

    public init(severity: ViolationSeverity, value: T)
}

public class RuleStorage {
    public init()
}

public struct StyleViolation: CustomStringConvertible, Equatable, Codable {
    public let ruleDescription: RuleDescription

    public let severity: ViolationSeverity

    public let location: Location

    public let reason: String

    public var description: String

    public init(ruleDescription: RuleDescription, severity: ViolationSeverity = .warning,
                location: Location, reason: String? = nil)
}

public struct SwiftVersion: RawRepresentable, Codable {
    public typealias RawValue = String

    public let rawValue: String

    public init(rawValue: String)
}

public extension SwiftVersion {
    static let three = SwiftVersion(rawValue: "3.0.0")

    static let four = SwiftVersion(rawValue: "4.0.0")

    static let fourDotOne = SwiftVersion(rawValue: "4.1.0")

    static let fourDotTwo = SwiftVersion(rawValue: "4.2.0")

    static let five = SwiftVersion(rawValue: "5.0.0")

    static let fiveDotOne = SwiftVersion(rawValue: "5.1.0")

    static let current: SwiftVersion =
}

public struct Version {
    public let value: String

    public static let current = Version(value: "0.35.0")
}

public enum ViolationSeverity: String, Comparable, Codable {
    public static func < (lhs: ViolationSeverity, rhs: ViolationSeverity) -> Bool
}

public struct YamlParser {
    public static func parse(_ yaml: String,
                             env: [String: String] = ProcessInfo.processInfo.environment) throws -> [String: Any]
}

public protocol ASTRule: Rule {
    associatedtype KindType: RawRepresentable

    func validate(file: File, kind: KindType, dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public extension ASTRule where KindType.RawValue == String {
    func validate(file: File) -> [StyleViolation]

    func validate(file: File, dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public protocol Reporter: CustomStringConvertible {
    static var identifier: String

    static var isRealtime: Bool

    static func generateReport(_ violations: [StyleViolation]) -> String
}

public func reporterFrom(identifier: String) -> Reporter.Type

public protocol Rule {
    static var description: RuleDescription

    var configurationDescription: String

    init() // Rules need to be able to be initialized with default values

    init(configuration: Any) throws

    func validate(file: File, compilerArguments: [String]) -> [StyleViolation]

    func validate(file: File) -> [StyleViolation]

    func isEqualTo(_ rule: Rule) -> Bool

    func collectInfo(for file: File, into storage: RuleStorage, compilerArguments: [String])

    func validate(file: File, using storage: RuleStorage, compilerArguments: [String]) -> [StyleViolation]
}

public protocol OptInRule: Rule

public protocol AutomaticTestableRule: Rule

public protocol ConfigurationProviderRule: Rule {
    associatedtype ConfigurationType: RuleConfiguration

    var configuration: ConfigurationType
}

public protocol CorrectableRule: Rule {
    func correct(file: File, compilerArguments: [String]) -> [Correction]

    func correct(file: File) -> [Correction]

    func correct(file: File, using storage: RuleStorage, compilerArguments: [String]) -> [Correction]
}

public extension CorrectableRule {
    func correct(file: File, compilerArguments: [String]) -> [Correction]

    func correct(file: File, using storage: RuleStorage, compilerArguments: [String]) -> [Correction]
}

public protocol SubstitutionCorrectableRule: CorrectableRule {
    func violationRanges(in file: File) -> [NSRange]

    func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public extension SubstitutionCorrectableRule {
    func correct(file: File) -> [Correction]
}

public protocol SubstitutionCorrectableASTRule: SubstitutionCorrectableRule, ASTRule {}

public protocol SourceKitFreeRule: Rule

public protocol AnalyzerRule: OptInRule

public extension AnalyzerRule {
    func validate(file: File) -> [StyleViolation]
}

public extension AnalyzerRule where Self: CorrectableRule {
    func correct(file: File) -> [Correction]
}

/// Type-erased protocol used to check whether a rule is collectable.
public protocol AnyCollectingRule: Rule

public protocol CollectingRule: AnyCollectingRule {
    associatedtype FileInfo

    func collectInfo(for file: File, compilerArguments: [String]) -> FileInfo

    func collectInfo(for file: File) -> FileInfo

    func validate(file: File, collectedInfo: [File: FileInfo], compilerArguments: [String]) -> [StyleViolation]

    func validate(file: File, collectedInfo: [File: FileInfo]) -> [StyleViolation]
}

public extension CollectingRule {
    func collectInfo(for file: File, into storage: RuleStorage, compilerArguments: [String])

    func validate(file: File, using storage: RuleStorage, compilerArguments: [String]) -> [StyleViolation]

    func collectInfo(for file: File, compilerArguments: [String]) -> FileInfo

    func validate(file: File, collectedInfo: [File: FileInfo], compilerArguments: [String]) -> [StyleViolation]

    func validate(file: File) -> [StyleViolation]

    func validate(file: File, compilerArguments: [String]) -> [StyleViolation]
}

public extension CollectingRule where Self: AnalyzerRule {
    func collectInfo(for file: File) -> FileInfo

    func validate(file: File) -> [StyleViolation]

    func validate(file: File, collectedInfo: [File: FileInfo]) -> [StyleViolation]
}

public protocol CollectingCorrectableRule: CollectingRule, CorrectableRule {
    func correct(file: File, collectedInfo: [File: FileInfo], compilerArguments: [String]) -> [Correction]

    func correct(file: File, collectedInfo: [File: FileInfo]) -> [Correction]
}

public extension CollectingCorrectableRule {
    func correct(file: File, collectedInfo: [File: FileInfo], compilerArguments: [String]) -> [Correction]

    func correct(file: File, using storage: RuleStorage, compilerArguments: [String]) -> [Correction]

    func correct(file: File) -> [Correction]

    func correct(file: File, compilerArguments: [String]) -> [Correction]
}

public extension CollectingCorrectableRule where Self: AnalyzerRule {
    func correct(file: File) -> [Correction]

    func correct(file: File, compilerArguments: [String]) -> [Correction]

    func correct(file: File, collectedInfo: [File: FileInfo]) -> [Correction]
}

public extension ConfigurationProviderRule {
    init(configuration: Any) throws

    func isEqualTo(_ rule: Rule) -> Bool

    var configurationDescription: String
}

public extension Array where Element == Rule {
    static func == (lhs: Array, rhs: Array) -> Bool
}

public protocol RuleConfiguration {
    var consoleDescription: String

    mutating func apply(configuration: Any) throws

    func isEqualTo(_ ruleConfiguration: RuleConfiguration) -> Bool
}

public extension RuleConfiguration where Self: Equatable {
    func isEqualTo(_ ruleConfiguration: RuleConfiguration) -> Bool
}

public struct CSVReporter: Reporter {
    public static let identifier = "csv"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct CheckstyleReporter: Reporter {
    public static let identifier = "checkstyle"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct EmojiReporter: Reporter {
    public static let identifier = "emoji"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct HTMLReporter: Reporter {
    public static let identifier = "html"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct JSONReporter: Reporter {
    public static let identifier = "json"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct JUnitReporter: Reporter {
    public static let identifier = "junit"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct MarkdownReporter: Reporter {
    public static let identifier = "markdown"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct SonarQubeReporter: Reporter {
    public static let identifier = "sonarqube"

    public static let isRealtime = false

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct XcodeReporter: Reporter {
    public static let identifier = "xcode"

    public static let isRealtime = true

    public var description: String

    public static func generateReport(_ violations: [StyleViolation]) -> String
}

public struct BlockBasedKVORule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ConvenienceTypeRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DiscouragedObjectLiteralRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = ObjectLiteralConfiguration()

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DiscouragedOptionalBooleanRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct DiscouragedOptionalCollectionRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DuplicateImportsRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ExplicitACLRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ExplicitEnumRawValueRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ExplicitInitRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule, OptInRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func violationRanges(in file: File, kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct ExplicitTopLevelACLRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ExplicitTypeInterfaceRule: OptInRule, ConfigurationProviderRule {
    public var configuration = ExplicitTypeInterfaceConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ExtensionAccessModifierRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct FallthroughRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FatalErrorMessageRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct FileNameRule: ConfigurationProviderRule, OptInRule {
    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ForWhereRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ForceCastRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ForceTryRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ForceUnwrappingRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FunctionDefaultParameterAtEndRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct GenericTypeNameRule: ASTRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File) -> [StyleViolation]

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ImplicitlyUnwrappedOptionalRule: ASTRule, ConfigurationProviderRule, OptInRule {
    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct IsDisjointRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct JoinedDefaultParameterRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule, OptInRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File,
                                kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct LegacyCGGeometryFunctionsRule: CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct LegacyConstantRule: CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct LegacyConstructorRule: ASTRule, CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct LegacyHashingRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct LegacyMultipleRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct LegacyNSGeometryFunctionsRule: CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct LegacyRandomRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(
        file: File,
        kind: SwiftExpressionKind,
        dictionary: [String: SourceKitRepresentable]
    ) -> [StyleViolation]
}

public struct NimbleOperatorRule: ConfigurationProviderRule, OptInRule, CorrectableRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct NoExtensionAccessModifierRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct NoFallthroughOnlyRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct NoGroupingExtensionRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ObjectLiteralRule: ASTRule, ConfigurationProviderRule, OptInRule {
    public var configuration = ObjectLiteralConfiguration()

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct PatternMatchingKeywordsRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct PrivateOverFilePrivateRule: ConfigurationProviderRule, SubstitutionCorrectableRule {
    public var configuration = PrivateOverFilePrivateRuleConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct RedundantNilCoalescingRule: OptInRule, SubstitutionCorrectableRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File) -> [NSRange]
}

public struct RedundantObjcAttributeRule: SubstitutionCorrectableRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]
}

public extension RedundantObjcAttributeRule {
    func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct RedundantOptionalInitializationRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File, kind: SwiftDeclarationKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct RedundantSetAccessControlRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct RedundantStringEnumValueRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct RedundantTypeAnnotationRule: OptInRule, SubstitutionCorrectableRule,
    ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File) -> [NSRange]
}

public struct RedundantVoidReturnRule: ConfigurationProviderRule, SubstitutionCorrectableASTRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func violationRanges(in file: File, kind: SwiftDeclarationKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct StaticOperatorRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct StrictFilePrivateRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct SyntacticSugarRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ToggleBoolRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct TrailingSemicolonRule: SubstitutionCorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct TypeNameRule: ASTRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File) -> [StyleViolation]

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct UnavailableFunctionRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct UnneededBreakInSwitchRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct UntypedErrorInCatchRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct UnusedEnumeratedRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct XCTFailMessageRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct XCTSpecificMatcherRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct AnyObjectProtocolRule: SubstitutionCorrectableASTRule, OptInRule,
    ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File,
                                kind: SwiftDeclarationKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct ArrayInitRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ClassDelegateProtocolRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct CompilerProtocolInitRule: ASTRule, ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DeploymentTargetRule: ConfigurationProviderRule {
    public var configuration = DeploymentTargetConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct DiscardedNotificationCenterObserverRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DiscouragedDirectInitRule: ASTRule, ConfigurationProviderRule {
    public var configuration = DiscouragedDirectInitConfiguration()

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DuplicateEnumCasesRule: ConfigurationProviderRule, ASTRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct DynamicInlineRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct EmptyXCTestMethodRule: Rule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct IdenticalOperandsRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct InertDeferRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct LowerACLThanParentRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct MarkRule: CorrectableRule, ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct MissingDocsRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public init()

    public typealias ConfigurationType = MissingDocsRuleConfiguration

    public var configuration: MissingDocsRuleConfiguration

    public func validate(file: File) -> [StyleViolation]
}

public struct NSLocalizedStringKeyRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct NSLocalizedStringRequireBundleRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct NSObjectPreferIsEqualRule: Rule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct NotificationCenterDetachmentRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct OverriddenSuperCallRule: ConfigurationProviderRule, ASTRule, OptInRule, AutomaticTestableRule {
    public var configuration = OverridenSuperCallConfiguration()

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct OverrideInExtensionRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct PrivateActionRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct PrivateOutletRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = PrivateOutletRuleConfiguration(allowPrivateSet: false)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct PrivateUnitTestRule: ASTRule, ConfigurationProviderRule, CacheDescriptionProvider, AutomaticTestableRule {
    public var configuration: PrivateUnitTestConfiguration =

        public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ProhibitedInterfaceBuilderRule: ConfigurationProviderRule, ASTRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ProhibitedSuperRule: ConfigurationProviderRule, ASTRule, OptInRule, AutomaticTestableRule {
    public var configuration = ProhibitedSuperConfiguration()

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct QuickDiscouragedCallRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct QuickDiscouragedFocusedTestRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct QuickDiscouragedPendingTestRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

/// Rule to require all classes to have a deinit method
/// An example of when this is useful is if the project does allocation tracking
/// of objects and the deinit should print a message or remove its instance from a
/// list of allocations. Even having an empty deinit method is useful to provide
/// a place to put a breakpoint when chasing down leaks.
public struct RequiredDeinitRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

/// Allows for Enums that conform to a protocol to require that a specific case be present.
/// This is primarily for result enums where a specific case is common but cannot be inherited due to cases not being
/// inheritable.
/// For example: A result enum is used to define all of the responses a client must handle from a specific service call
/// in an API.
/// ````
/// enum MyServiceCallResponse: String {
///     case unauthorized
///     case unknownError
///     case accountCreated
/// }
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
/// If cases could be inherited you could put all of the common ones in an enum and then inherit from that enum:
/// ````
/// enum MyServiceResponse: String {
///     case unauthorized
///     case unknownError
/// }
/// enum MyServiceCallResponse: MyServiceResponse {
///     case accountCreated
/// }
/// ````
/// Which would result in MyServiceCallResponse having all of the cases when compiled:
/// ```
/// enum MyServiceCallResponse: MyServiceResponse {
///     case unauthorized
///     case unknownError
///     case accountCreated
/// }
/// ```
/// Since that cannot be done this rule allows you to define cases that should be present if conforming to a protocol.
/// `.swiftlint.yml`
/// ````
/// required_enum_case:
///   MyServiceResponse:
///     unauthorized: error
///     unknownError: error
/// ````
/// ````
/// protocol MyServiceResponse {}
/// // This will now have errors because `unauthorized` and `unknownError` are not present.
/// enum MyServiceCallResponse: String, MyServiceResponse {
///     case accountCreated
/// }
/// ````
public struct RequiredEnumCaseRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = RequiredEnumCaseRuleConfiguration()

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct StrongIBOutletRule: ConfigurationProviderRule, ASTRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct SuperfluousDisableCommandRule: ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func reason(for rule: Rule.Type) -> String

    public func reason(for rule: String) -> String

    public func reason(forNonExistentRule rule: String) -> String
}

public extension SyntaxKind {
    /// Returns if the syntax kind is comment-like.
    var isCommentLike: Bool
}

public struct TodoRule: ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct UnownedVariableCaptureRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct UnusedCaptureListRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct UnusedClosureParameterRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func violationRanges(in file: File, kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct UnusedControlFlowLabelRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File, kind: StatementKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct UnusedDeclarationRule: AutomaticTestableRule, ConfigurationProviderRule, AnalyzerRule, CollectingRule {
    public struct FileUSRs {}

    public typealias FileInfo = FileUSRs

    public var configuration = UnusedDeclarationConfiguration(severity: .error, includePublicAndOpen: false)

    public init()

    public func collectInfo(for file: File, compilerArguments: [String]) -> UnusedDeclarationRule.FileUSRs

    public func validate(file: File, collectedInfo: [File: UnusedDeclarationRule.FileUSRs],
                         compilerArguments: [String]) -> [StyleViolation]
}

public struct UnusedImportRule: CorrectableRule, ConfigurationProviderRule, AnalyzerRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, compilerArguments: [String]) -> [StyleViolation]

    public func correct(file: File, compilerArguments: [String]) -> [Correction]
}

public struct UnusedSetterValueRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ValidIBInspectableRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct WeakDelegateRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct YodaConditionRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ClosureBodyLengthRule: OptInRule, ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityLevelsConfiguration(warning: 20, error: 100)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct CyclomaticComplexityRule: ASTRule, ConfigurationProviderRule {
    public var configuration = CyclomaticComplexityConfiguration(warning: 10, error: 20)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct FileLengthRule: ConfigurationProviderRule {
    public var configuration = FileLengthRuleConfiguration(warning: 400, error: 1000)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FunctionBodyLengthRule: ASTRule, ConfigurationProviderRule {
    public var configuration = SeverityLevelsConfiguration(warning: 40, error: 100)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct FunctionParameterCountRule: ASTRule, ConfigurationProviderRule {
    public var configuration = FunctionParameterCountConfiguration(warning: 5, error: 8)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct LargeTupleRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityLevelsConfiguration(warning: 2, error: 3)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct LineLengthRule: ConfigurationProviderRule {
    public var configuration = LineLengthConfiguration(warning: 120, error: 200)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct NestingRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct TypeBodyLengthRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityLevelsConfiguration(warning: 200, error: 350)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ContainsOverFilterCountRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ContainsOverFilterIsEmptyRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ContainsOverFirstNotNilRule: CallPairRule, OptInRule, ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ContainsOverRangeNilComparisonRule: CallPairRule, OptInRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct EmptyCollectionLiteralRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct EmptyCountRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct EmptyStringRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FirstWhereRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FlatMapOverMapReduceRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct LastWhereRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ReduceBooleanRule: Rule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ReduceIntoRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct SortedFirstLastRule: CallPairRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct AttributesConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(alwaysOnSameLine: [String] = ["@IBAction", "@NSManaged"],
                alwaysInNewLine: [String] = [])

    public mutating func apply(configuration: Any) throws
}

public struct CollectionAlignmentConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct ColonConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct ConditionalReturnsOnNewlineConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct CyclomaticComplexityConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public private(set) var length: SeverityLevelsConfiguration

    public private(set) var complexityStatements: Set<StatementKind>

    public private(set) var ignoresCaseStatements: Bool

    public init(warning: Int, error: Int?, ignoresCaseStatements: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct DeploymentTargetConfiguration: RuleConfiguration, Equatable {
    public struct Version: Equatable, Comparable {
        public let major: Int

        public let minor: Int

        public let patch: Int

        public var stringValue: String

        public init(major: Int, minor: Int = 0, patch: Int = 0)

        public init(rawValue: String) throws

        public static func < (lhs: Version, rhs: Version) -> Bool
    }

    public var consoleDescription: String

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct DiscouragedDirectInitConfiguration: RuleConfiguration, Equatable {
    public var severityConfiguration = SeverityConfiguration(.warning)

    public var consoleDescription: String

    public var severity: ViolationSeverity

    public private(set) var discouragedInits: Set<String>

    public mutating func apply(configuration: Any) throws
}

public struct ExplicitTypeInterfaceConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct FileHeaderConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct FileLengthRuleConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(warning: Int, error: Int?, ignoreCommentOnlyLines: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct FileNameConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public private(set) var severity: SeverityConfiguration

    public private(set) var excluded: Set<String>

    public private(set) var prefixPattern: String

    public private(set) var suffixPattern: String

    public private(set) var nestedTypeSeparator: String

    public init(severity: ViolationSeverity, excluded: [String] = [],
                prefixPattern: String = "", suffixPattern: String = "\\+.*", nestedTypeSeparator: String = ".")

    public mutating func apply(configuration: Any) throws
}

public struct FileTypesOrderConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct FunctionParameterCountConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(warning: Int, error: Int?, ignoresDefaultParameters: Bool = true)

    public mutating func apply(configuration: Any) throws
}

public enum ImplicitlyUnwrappedOptionalModeConfiguration: String {}

public struct ImplicitlyUnwrappedOptionalConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct LineLengthRuleOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int = 0)

    public static let ignoreURLs = LineLengthRuleOptions(rawValue: 1 << 0)

    public static let ignoreFunctionDeclarations = LineLengthRuleOptions(rawValue: 1 << 1)

    public static let ignoreComments = LineLengthRuleOptions(rawValue: 1 << 2)

    public static let ignoreInterpolatedStrings = LineLengthRuleOptions(rawValue: 1 << 3)
}

public struct LineLengthConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(warning: Int, error: Int?, options: LineLengthRuleOptions = [])

    public mutating func apply(configuration: Any) throws
}

public struct MissingDocsRuleConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct ModifierOrderConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(preferredModifierOrder: [SwiftDeclarationAttributeKind.ModifierGroup] = [])

    public mutating func apply(configuration: Any) throws
}

public struct MultilineArgumentsConfiguration: RuleConfiguration, Equatable {
    public enum FirstArgumentLocation: String {}

    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct NameConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(minLengthWarning: Int,
                minLengthError: Int,
                maxLengthWarning: Int,
                maxLengthError: Int,
                excluded: [String] = [],
                allowedSymbols: [String] = [],
                validatesStartWithLowercase: Bool = true)

    public mutating func apply(configuration: Any) throws
}

public extension ConfigurationProviderRule where ConfigurationType == NameConfiguration {
    func severity(forLength length: Int) -> ViolationSeverity?
}

public struct NestingConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(typeLevelWarning: Int,
                typeLevelError: Int?,
                statementLevelWarning: Int,
                statementLevelError: Int?)

    public mutating func apply(configuration: Any) throws
}

public struct NumberSeparatorConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(minimumLength: Int, minimumFractionLength: Int?, excludeRanges: [Range<Double>])

    public mutating func apply(configuration: Any) throws
}

public struct ObjectLiteralConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct OverridenSuperCallConfiguration: RuleConfiguration, Equatable {
    public private(set) var resolvedMethodNames: [String]

    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws

    public var severity: ViolationSeverity
}

public struct PrefixedConstantRuleConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(onlyPrivateMembers: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct PrivateOutletRuleConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(allowPrivateSet: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct PrivateOverFilePrivateRuleConfiguration: RuleConfiguration, Equatable {
    public var severityConfiguration = SeverityConfiguration(.warning)

    public var validateExtensions = false

    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct PrivateUnitTestConfiguration: RuleConfiguration, Equatable, CacheDescriptionProvider {
    public let identifier: String

    public var name: String?

    public var message = "Regex matched."

    public var regex: NSRegularExpression!

    public var included: NSRegularExpression?

    public var severityConfiguration = SeverityConfiguration(.warning)

    public var severity: ViolationSeverity

    public var consoleDescription: String

    public init(identifier: String)

    public mutating func apply(configuration: Any) throws
}

public struct ProhibitedSuperConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws

    public var severity: ViolationSeverity
}

public struct RegexConfiguration: RuleConfiguration, Hashable, CacheDescriptionProvider {
    public let identifier: String

    public var name: String?

    public var message = "Regex matched."

    public var regex: NSRegularExpression!

    public var included: NSRegularExpression?

    public var excluded: NSRegularExpression?

    public var matchKinds = SyntaxKind.allKinds

    public var severityConfiguration = SeverityConfiguration(.warning)

    public var severity: ViolationSeverity

    public var consoleDescription: String

    public var description: RuleDescription

    public init(identifier: String)

    public mutating func apply(configuration: Any) throws

    public func hash(into hasher: inout Hasher)
}

public struct RequiredEnumCaseRuleConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct SeverityConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(_ severity: ViolationSeverity)

    public mutating func apply(configuration: Any) throws
}

public struct SeverityLevelsConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public var shortConsoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public enum StatementModeConfiguration: String {}

public struct StatementConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(statementMode: StatementModeConfiguration,
                severity: SeverityConfiguration)

    public mutating func apply(configuration: Any) throws
}

public struct SwitchCaseAlignmentConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct TrailingClosureConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(onlySingleMutedParameter: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct TrailingCommaConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(mandatoryComma: Bool = false)

    public mutating func apply(configuration: Any) throws
}

public struct TrailingWhitespaceConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(ignoresEmptyLines: Bool, ignoresComments: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct TypeContentsOrderConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public mutating func apply(configuration: Any) throws
}

public struct UnusedDeclarationConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(severity: ViolationSeverity, includePublicAndOpen: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct UnusedOptionalBindingConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(ignoreOptionalTry: Bool)

    public mutating func apply(configuration: Any) throws
}

public struct VerticalWhitespaceConfiguration: RuleConfiguration, Equatable {
    public var consoleDescription: String

    public init(maxEmptyLines: Int)

    public mutating func apply(configuration: Any) throws
}

public struct AttributesRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = AttributesConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ClosingBraceRule: SubstitutionCorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct ClosureEndIndentationRule: Rule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ClosureParameterPositionRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ClosureSpacingRule: CorrectableRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct CollectionAlignmentRule: ASTRule, ConfigurationProviderRule, OptInRule {
    public var configuration = CollectionAlignmentConfiguration()

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ColonRule: CorrectableRule, ConfigurationProviderRule {
    public var configuration = ColonConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct CommaRule: SubstitutionCorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File) -> [NSRange]
}

public struct ConditionalReturnsOnNewlineRule: ConfigurationProviderRule, Rule, OptInRule {
    public var configuration = ConditionalReturnsOnNewlineConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ControlStatementRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct CustomRulesConfiguration: RuleConfiguration, Equatable, CacheDescriptionProvider {
    public var consoleDescription: String

    public var customRuleConfigurations = [RegexConfiguration]()

    public init()

    public mutating func apply(configuration: Any) throws
}

public struct CustomRules: Rule, ConfigurationProviderRule, CacheDescriptionProvider {
    public var configuration = CustomRulesConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct EmptyEnumArgumentsRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File, kind: StatementKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct EmptyParametersRule: ConfigurationProviderRule, SubstitutionCorrectableRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct EmptyParenthesesWithTrailingClosureRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File, kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct ExplicitSelfRule: CorrectableRule, ConfigurationProviderRule, AnalyzerRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, compilerArguments: [String]) -> [StyleViolation]

    public func correct(file: File, compilerArguments: [String]) -> [Correction]
}

public struct FileHeaderRule: ConfigurationProviderRule, OptInRule {
    public var configuration = FileHeaderConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct FileTypesOrderRule: ConfigurationProviderRule, OptInRule {
    public var configuration = FileTypesOrderConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct IdentifierNameRule: ASTRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ImplicitGetterRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ImplicitReturnRule: ConfigurationProviderRule, SubstitutionCorrectableRule, OptInRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File) -> [NSRange]
}

public struct LeadingWhitespaceRule: CorrectableRule, ConfigurationProviderRule, SourceKitFreeRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct LetVarWhitespaceRule: ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct LiteralExpressionEndIdentationRule: Rule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct ModifierOrderRule: ASTRule, OptInRule, ConfigurationProviderRule, CorrectableRule {
    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct MultilineArgumentsBracketsRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct MultilineArgumentsRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = MultilineArgumentsConfiguration()

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct MultilineFunctionChainsRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct MultilineLiteralBracketsRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct MultilineParametersBracketsRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct MultilineParametersRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct MultipleClosuresWithTrailingClosureRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct NoSpaceInMethodCallRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File,
                         kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File,
                                kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]
}

public struct NumberSeparatorRule: OptInRule, CorrectableRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct OpeningBraceRule: CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct OperatorFunctionWhitespaceRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct OperatorUsageWhitespaceRule: OptInRule, CorrectableRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct PrefixedTopLevelConstantRule: ASTRule, OptInRule, ConfigurationProviderRule {
    public var configuration = PrefixedConstantRuleConfiguration(onlyPrivateMembers: false)

    public init()

    public func validate(file: File,
                         kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct ProtocolPropertyAccessorsOrderRule: ConfigurationProviderRule, SubstitutionCorrectableRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct RedundantDiscardableLetRule: SubstitutionCorrectableRule, ConfigurationProviderRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)

    public func violationRanges(in file: File) -> [NSRange]
}

public struct ReturnArrowWhitespaceRule: CorrectableRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct ShorthandOperatorRule: ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.error)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct SingleTestClassRule: Rule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct SortedImportsRule: CorrectableRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct StatementPositionRule: CorrectableRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct SwitchCaseAlignmentRule: ASTRule, ConfigurationProviderRule {
    public var configuration = SwitchCaseAlignmentConfiguration()

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct SwitchCaseOnNewlineRule: ASTRule, ConfigurationProviderRule, OptInRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct TrailingClosureRule: OptInRule, ConfigurationProviderRule {
    public var configuration = TrailingClosureConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct TrailingCommaRule: SubstitutionCorrectableASTRule, ConfigurationProviderRule {
    public var configuration = TrailingCommaConfiguration()

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]

    public func violationRanges(in file: File, kind: SwiftExpressionKind,
                                dictionary: [String: SourceKitRepresentable]) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}

public struct TrailingNewlineRule: CorrectableRule, ConfigurationProviderRule, SourceKitFreeRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct TrailingWhitespaceRule: CorrectableRule, ConfigurationProviderRule {
    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct TypeContentsOrderRule: ConfigurationProviderRule, OptInRule {
    public var configuration = TypeContentsOrderConfiguration()

    public init()

    public func validate(file: File) -> [StyleViolation]
}

public struct UnneededParenthesesInClosureArgumentRule: ConfigurationProviderRule, CorrectableRule, OptInRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct UnusedOptionalBindingRule: ASTRule, ConfigurationProviderRule {
    public var configuration = UnusedOptionalBindingConfiguration(ignoreOptionalTry: false)

    public init()

    public func validate(file: File,
                         kind: StatementKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct VerticalParameterAlignmentOnCallRule: ASTRule, ConfigurationProviderRule, OptInRule,
    AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftExpressionKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct VerticalParameterAlignmentRule: ASTRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File, kind: SwiftDeclarationKind,
                         dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
}

public struct VerticalWhitespaceBetweenCasesRule: ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()
}

public struct VerticalWhitespaceClosingBracesRule: ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()
}

public struct VerticalWhitespaceOpeningBracesRule: ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()
}

public struct VerticalWhitespaceRule: CorrectableRule, ConfigurationProviderRule {
    public var configuration = VerticalWhitespaceConfiguration(maxEmptyLines: 1)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func correct(file: File) -> [Correction]
}

public struct VoidReturnRule: ConfigurationProviderRule, SubstitutionCorrectableRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init()

    public func validate(file: File) -> [StyleViolation]

    public func violationRanges(in file: File) -> [NSRange]

    public func substitution(for violationRange: NSRange, in file: File) -> (NSRange, String)
}
