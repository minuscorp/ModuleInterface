import Foundation
import SwiftOnoneSupport

/// Applies `f` to the value in the given result.
///
/// In the context of command-line option parsing, this is used to chain
/// together the parsing of multiple arguments. See OptionsProtocol for an example.
public func <*> <T, U, ClientError>(f: (T) -> U, value: Result<T, Commandant.CommandantError<ClientError>>) -> Result<U, Commandant.CommandantError<ClientError>>

/// Applies the function in `f` to the value in the given result.
///
/// In the context of command-line option parsing, this is used to chain
/// together the parsing of multiple arguments. See OptionsProtocol for an example.
public func <*> <T, U, ClientError>(f: Result<(T) -> U, Commandant.CommandantError<ClientError>>, value: Result<T, Commandant.CommandantError<ClientError>>) -> Result<U, Commandant.CommandantError<ClientError>>

/// Describes an argument that can be provided on the command line.
public struct Argument<T> {
    /// The default value for this argument. This is the value that will be used
    /// if the argument is never explicitly specified on the command line.
    ///
    /// If this is nil, this argument is always required.
    public let defaultValue: T?

    /// A human-readable string describing the purpose of this argument. This will
    /// be shown in help messages.
    public let usage: String

    /// A human-readable string that describes this argument as a paramater shown
    /// in the list of possible parameters in help messages (e.g. for "paths", the
    /// user would see <paths…>).
    public let usageParameter: String?

    public init(defaultValue: T? = nil, usage: String, usageParameter: String? = nil)
}

/// Destructively parses a list of command-line arguments.
public final class ArgumentParser {
    /// Initializes the generator from a simple list of command-line arguments.
    public init(_ arguments: [String])
}

/// Represents a value that can be converted from a command-line argument.
public protocol ArgumentProtocol {
    /// A human-readable name for this type.
    static var name: String { get }

    /// Attempts to parse a value from the given command-line argument.
    static func from(string: String) -> Self?
}

/// Describes the "mode" in which a command should run.
public enum CommandMode {
    /// Options should be parsed from the given command-line arguments.
    case arguments(Commandant.ArgumentParser)

    /// Each option should record its usage information in an error, for
    /// presentation to the user.
    case usage
}

extension CommandMode {
    /// Evaluates the given argument in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the argument's `defaultValue` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, argument: Commandant.Argument<T>) -> Result<T, Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol

    /// Evaluates the given argument list in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the argument's `defaultValue` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, argument: Commandant.Argument<[T]>) -> Result<[T], Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol
}

extension CommandMode {
    /// Evaluates the given option in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the option's `defaultValue` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, option: Commandant.Option<T>) -> Result<T, Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol

    /// Evaluates the given option in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, `nil` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, option: Commandant.Option<T?>) -> Result<T?, Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol

    /// Evaluates the given option in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the option's `defaultValue` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, option: Commandant.Option<[T]>) -> Result<[T], Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol

    /// Evaluates the given option in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, `nil` is used.
    public static func <| <T, ClientError>(mode: Commandant.CommandMode, option: Commandant.Option<[T]?>) -> Result<[T]?, Commandant.CommandantError<ClientError>> where T: Commandant.ArgumentProtocol

    /// Evaluates the given boolean option in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the option's `defaultValue` is used.
    public static func <| <ClientError>(mode: Commandant.CommandMode, option: Commandant.Option<Bool>) -> Result<Bool, Commandant.CommandantError<ClientError>>
}

extension CommandMode {
    /// Evaluates the given boolean switch in the given mode.
    ///
    /// If parsing command line arguments, and no value was specified on the command
    /// line, the option's `defaultValue` is used.
    public static func <| <ClientError>(mode: Commandant.CommandMode, option: Commandant.Switch) -> Result<Bool, Commandant.CommandantError<ClientError>>
}

/// Represents a subcommand that can be executed with its own set of arguments.
public protocol CommandProtocol {
    /// The command's options type.
    associatedtype Options: Commandant.OptionsProtocol

    associatedtype ClientError where Self.ClientError == Self.Options.ClientError

    /// The action that users should specify to use this subcommand (e.g.,
    /// `help`).
    var verb: String { get }

    /// A human-readable, high-level description of what this command is used
    /// for.
    var function: String { get }

    /// Runs this subcommand with the given options.
    func run(_ options: Self.Options) -> Result<Void, Self.ClientError>
}

/// Maintains the list of commands available to run.
public final class CommandRegistry<ClientError> where ClientError: Error {
    /// All available commands.
    public var commands: [Commandant.CommandWrapper<ClientError>] { get }

    public init()

    /// Registers the given commands, making those available to run.
    ///
    /// If another commands were already registered with the same `verb`s, those
    /// will be overwritten.
    public func register<C>(_ commands: C...) -> Commandant.CommandRegistry<ClientError> where ClientError == C.ClientError, C: Commandant.CommandProtocol

    /// Runs the command corresponding to the given verb, passing it the given
    /// arguments.
    ///
    /// Returns the results of the execution, or nil if no such command exists.
    public func run(command verb: String, arguments: [String]) -> Result<Void, Commandant.CommandantError<ClientError>>?

    /// Returns the command matching the given verb, or nil if no such command
    /// is registered.
    public subscript(_: String) -> Commandant.CommandWrapper<ClientError>? { get }
}

extension CommandRegistry {
    /// Hands off execution to the CommandRegistry, by parsing CommandLine.arguments
    /// and then running whichever command has been identified in the argument
    /// list.
    ///
    /// If the chosen command executes successfully, the process will exit with
    /// a successful exit code.
    ///
    /// If the chosen command fails, the provided error handler will be invoked,
    /// then the process will exit with a failure exit code.
    ///
    /// If a matching command could not be found but there is any `executable-verb`
    /// style subcommand executable in the caller's `$PATH`, the subcommand will
    /// be executed.
    ///
    /// If a matching command could not be found or a usage error occurred,
    /// a helpful error message will be written to `stderr`, then the process
    /// will exit with a failure error code.
    public func main(defaultVerb: String, errorHandler: (ClientError) -> Void) -> Never

    /// Hands off execution to the CommandRegistry, by parsing `arguments`
    /// and then running whichever command has been identified in the argument
    /// list.
    ///
    /// If the chosen command executes successfully, the process will exit with
    /// a successful exit code.
    ///
    /// If the chosen command fails, the provided error handler will be invoked,
    /// then the process will exit with a failure exit code.
    ///
    /// If a matching command could not be found but there is any `executable-verb`
    /// style subcommand executable in the caller's `$PATH`, the subcommand will
    /// be executed.
    ///
    /// If a matching command could not be found or a usage error occurred,
    /// a helpful error message will be written to `stderr`, then the process
    /// will exit with a failure error code.
    public func main(arguments: [String], defaultVerb: String, errorHandler: (ClientError) -> Void) -> Never
}

/// A type-erased command.
public struct CommandWrapper<ClientError> where ClientError: Error {
    public let verb: String

    public let function: String

    public let run: (Commandant.ArgumentParser) -> Result<Void, Commandant.CommandantError<ClientError>>

    public let usage: () -> Commandant.CommandantError<ClientError>?
}

/// Possible errors that can originate from Commandant.
///
/// `ClientError` should be the type of error (if any) that can occur when
/// running commands.
public enum CommandantError<ClientError>: Error {
    /// An option was used incorrectly.
    case usageError(description: String)

    /// An error occurred while running a command.
    case commandError(ClientError)
}

extension CommandantError: CustomStringConvertible {
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

/// A basic implementation of a `help` command, using information available in a
/// `CommandRegistry`.
///
/// If you want to use this command, initialize it with the registry, then add
/// it to that same registry:
///
/// 	let commands: CommandRegistry<MyErrorType> = …
/// 	let helpCommand = HelpCommand(registry: commands)
/// 	commands.register(helpCommand)
public struct HelpCommand<ClientError>: Commandant.CommandProtocol where ClientError: Error {
    /// The command's options type.
    public typealias Options = Commandant.HelpOptions<ClientError>

    /// The action that users should specify to use this subcommand (e.g.,
    /// `help`).
    public let verb: String

    /// A human-readable, high-level description of what this command is used
    /// for.
    public let function: String

    /// Initializes the command to provide help from the given registry of
    /// commands.
    public init(registry: Commandant.CommandRegistry<ClientError>, function: String? = nil)

    /// Runs this subcommand with the given options.
    public func run(_ options: Commandant.HelpCommand<ClientError>.Options) -> Result<Void, ClientError>
}

public struct HelpOptions<ClientError>: Commandant.OptionsProtocol where ClientError: Error {
    /// Evaluates this set of options in the given mode.
    ///
    /// Returns the parsed options or a `UsageError`.
    public static func evaluate(_ m: Commandant.CommandMode) -> Result<Commandant.HelpOptions<ClientError>, Commandant.CommandantError<ClientError>>
}

/// An `OptionsProtocol` that has no options.
public struct NoOptions<ClientError>: Commandant.OptionsProtocol where ClientError: Error {
    public init()

    /// Evaluates this set of options in the given mode.
    ///
    /// Returns the parsed options or a `UsageError`.
    public static func evaluate(_ m: Commandant.CommandMode) -> Result<Commandant.NoOptions<ClientError>, Commandant.CommandantError<ClientError>>
}

/// Describes an option that can be provided on the command line.
public struct Option<T> {
    /// The key that controls this option. For example, a key of `verbose` would
    /// be used for a `--verbose` option.
    public let key: String

    /// The default value for this option. This is the value that will be used
    /// if the option is never explicitly specified on the command line.
    public let defaultValue: T

    /// A human-readable string describing the purpose of this option. This will
    /// be shown in help messages.
    ///
    /// For boolean operations, this should describe the effect of _not_ using
    /// the default value (i.e., what will happen if you disable/enable the flag
    /// differently from the default).
    public let usage: String

    public init(key: String, defaultValue: T, usage: String)
}

extension Option: CustomStringConvertible {
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

/// Represents a record of options for a command, which can be parsed from
/// a list of command-line arguments.
///
/// This is most helpful when used in conjunction with the `Option` and `Switch`
/// types, and `<*>` and `<|` combinators.
///
/// Example:
///
/// 		struct LogOptions: OptionsProtocol {
/// 			let verbosity: Int
/// 			let outputFilename: String
/// 			let shouldDelete: Bool
/// 			let logName: String
///
/// 			static func create(_ verbosity: Int) -> (String) -> (Bool) -> (String) -> LogOptions {
/// 				return { outputFilename in { shouldDelete in { logName in LogOptions(verbosity: verbosity, outputFilename: outputFilename, shouldDelete: shouldDelete, logName: logName) } } }
/// 			}
///
/// 			static func evaluate(_ m: CommandMode) -> Result<LogOptions, CommandantError<YourErrorType>> {
/// 				return create
/// 					<*> m <| Option(key: "verbose", defaultValue: 0, usage: "the verbosity level with which to read the logs")
/// 					<*> m <| Option(key: "outputFilename", defaultValue: "", usage: "a file to print output to, instead of stdout")
/// 					<*> m <| Switch(flag: "d", key: "delete", usage: "delete the logs when finished")
/// 					<*> m <| Argument(usage: "the log to read")
/// 			}
/// 		}
public protocol OptionsProtocol {
    associatedtype ClientError: Error

    /// Evaluates this set of options in the given mode.
    ///
    /// Returns the parsed options or a `UsageError`.
    static func evaluate(_ m: Commandant.CommandMode) -> Result<Self, Commandant.CommandantError<Self.ClientError>>
}

/// Describes a parameterless command line flag that defaults to false and can only
/// be switched on. Canonical examples include `--force` and `--recurse`.
///
/// For a boolean toggle that can be enabled and disabled use `Option<Bool>`.
public struct Switch {
    /// The key that enables this switch. For example, a key of `verbose` would be
    /// used for a `--verbose` option.
    public let key: String

    /// Optional single letter flag that enables this switch. For example, `-v` would
    /// be used as a shorthand for `--verbose`.
    ///
    /// Multiple flags can be grouped together as a single argument and will split
    /// when parsing (e.g. `rm -rf` treats 'r' and 'f' as inidividual flags).
    public let flag: Character?

    /// A human-readable string describing the purpose of this option. This will
    /// be shown in help messages.
    public let usage: String

    public init(flag: Character? = nil, key: String, usage: String)
}

extension Switch: CustomStringConvertible {
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

extension Int: Commandant.ArgumentProtocol {
    /// A human-readable name for this type.
    public static let name: String

    /// Attempts to parse a value from the given command-line argument.
    public static func from(string: String) -> Int?
}

extension String: Commandant.ArgumentProtocol {
    /// A human-readable name for this type.
    public static let name: String

    /// Attempts to parse a value from the given command-line argument.
    public static func from(string: String) -> String?
}

extension RawRepresentable where Self: Commandant.ArgumentProtocol, Self.RawValue: StringProtocol {
    public static func from(string: String) -> Self?
}

extension RawRepresentable where Self: Commandant.ArgumentProtocol, Self.RawValue: FixedWidthInteger {
    public static func from(string: String) -> Self?
}

infix operator <*>: LogicalDisjunctionPrecedence

infix operator <|: MultiplicationPrecedence
