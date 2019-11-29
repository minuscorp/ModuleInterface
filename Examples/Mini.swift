import Dispatch
import Foundation
import NIOConcurrencyHelpers
import RxSwift
import SwiftOnoneSupport

/**
 Protocol that has to be conformed by any object that can be dispatcher
 by a `Dispatcher` object.
 */
public protocol Action {
    /// Equality function between `Action` objects
    /// - Returns: If an `Action` is the same as other.
    func isEqual(to other: Mini.Action) -> Bool
}

extension Action {
    /// String used as tag of the given Action based on his name.
    /// - Returns: The name of the action as a String.
    public var innerTag: String { get }
}

extension Action {
    /// Equality operator between `Action` objects.
    /// - Returns: If the `Action`s are equal or not.
    public static func == (lhs: Self, rhs: Self) -> Bool
}

extension Action where Self: Equatable {
    /// Convenience `isEqual` implementation when the `Action` object
    /// implements `Equatable`.
    /// - Returns: Whether the `Action` object is the same as other.
    public func isEqual(to other: Mini.Action) -> Bool
}

public protocol Chain {
    var proceed: Mini.Next { get }
}

public protocol CompletableAction: Mini.Action, Mini.PayloadAction {}

public final class Dispatcher {
    public struct DispatchMode {
        public enum UI {
            case sync

            case async
        }
    }

    public var subscriptionCount: Int { get }

    public static let defaultPriority: Int

    public init()

    public func add(middleware: Mini.Middleware)

    public func remove(middleware: Mini.Middleware)

    public func register(service: Mini.Service)

    public func unregister(service: Mini.Service)

    public func subscribe(priority: Int, tag: String, completion: @escaping (Mini.Action) -> Void) -> Mini.DispatcherSubscription

    public func registerInternal(subscription: Mini.DispatcherSubscription) -> Mini.DispatcherSubscription

    public func unregisterInternal(subscription: Mini.DispatcherSubscription)

    public func subscribe<T>(completion: @escaping (T) -> Void) -> Mini.DispatcherSubscription where T: Mini.Action

    public func subscribe<T>(tag: String, completion: @escaping (T) -> Void) -> Mini.DispatcherSubscription where T: Mini.Action

    public func subscribe(tag: String, completion: @escaping (Mini.Action) -> Void) -> Mini.DispatcherSubscription

    public func dispatch(_ action: Mini.Action, mode: Mini.Dispatcher.DispatchMode.UI)
}

public final class DispatcherSubscription: Comparable, RxSwift.Disposable {
    public let id: Int

    public let tag: String

    public init(dispatcher: Mini.Dispatcher, id: Int, priority: Int, tag: String, completion: @escaping (Mini.Action) -> Void)

    /// Dispose resource.
    public func dispose()

    public func on(_ action: Mini.Action)

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Mini.DispatcherSubscription, rhs: Mini.DispatcherSubscription) -> Bool

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func > (lhs: Mini.DispatcherSubscription, rhs: Mini.DispatcherSubscription) -> Bool

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
    public static func < (lhs: Mini.DispatcherSubscription, rhs: Mini.DispatcherSubscription) -> Bool

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func >= (lhs: Mini.DispatcherSubscription, rhs: Mini.DispatcherSubscription) -> Bool

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func <= (lhs: Mini.DispatcherSubscription, rhs: Mini.DispatcherSubscription) -> Bool
}

public protocol EmptyAction: Mini.Action, Mini.PayloadAction where Self.Payload == Void {
    init(promise: Mini.Promise<Void>)
}

extension EmptyAction {
    public init(promise _: Mini.Promise<Self.Payload>)
}

public final class ForwardingChain: Mini.Chain {
    public var proceed: Mini.Next { get }

    public init(next: @escaping Mini.Next)
}

public protocol Group: RxSwift.Disposable {
    var disposeBag: RxSwift.CompositeDisposable { get }
}

public protocol KeyedCompletableAction: Mini.Action, Mini.KeyedPayloadAction {}

public protocol KeyedPayloadAction {
    associatedtype Payload

    associatedtype Key: Hashable

    init(promise: [Self.Key: Mini.Promise<Self.Payload>])
}

public protocol Middleware {
    var id: UUID { get }

    var perform: Mini.MiddlewareChain { get }
}

public typealias MiddlewareChain = (Mini.Action, Mini.Chain) -> Mini.Action

public typealias Next = (Mini.Action) -> Mini.Action

/**
 An Ordered Set is a collection where all items in the set follow an ordering,
 usually ordered from 'least' to 'most'. The way you value and compare items
 can be user-defined.
 */
public class OrderedSet<T> where T: Comparable {
    public init(initial: [T] = [])

    /// Returns the number of elements in the OrderedSet.
    public var count: Int { get }

    /// Inserts an item. Performance: O(n)
    public func insert(_ item: T) -> Bool

    /// Insert an array of items
    public func insert(_ items: [T]) -> Bool

    /// Removes an item if it exists. Performance: O(n)
    public func remove(_ item: T) -> Bool

    /// Returns true if and only if the item exists somewhere in the set.
    public func exists(_ item: T) -> Bool

    /// Returns the index of an item if it exists, or nil otherwise.
    public func indexOf(_ item: T) -> Int?

    /// Returns the item at the given index.
    /// Assertion fails if the index is out of the range of [0, count).
    public subscript(_: Int) -> T { get }

    /// Returns the 'maximum' or 'largest' value in the set.
    public var max: T? { get }

    /// Returns the 'minimum' or 'smallest' value in the set.
    public var min: T? { get }

    /// Returns the k-th largest element in the set, if k is in the range
    /// [1, count]. Returns nil otherwise.
    public func kLargest(element: Int) -> T?

    /// Returns the k-th smallest element in the set, if k is in the range
    /// [1, count]. Returns nil otherwise.
    public func kSmallest(element: Int) -> T?

    /// For each function
    public func forEach(_ body: (T) -> Void)

    /// Enumerated function
    public func enumerated() -> EnumeratedSequence<[T]>
}

public protocol PayloadAction {
    associatedtype Payload

    init(promise: Mini.Promise<Self.Payload>)
}

@dynamicMemberLookup public final class Promise<T>: Mini.PromiseType {
    public typealias Element = T

    public class func value(_ value: T) -> Mini.Promise<T>

    public class func error(_ error: Error) -> Mini.Promise<T>

    public init(error: Error)

    public init()

    public class func idle(with options: [String: Any] = [:]) -> Mini.Promise<T>

    public class func pending(options: [String: Any] = [:]) -> Mini.Promise<T>

    public var result: Result<T, Error>? { get }

    /// - Note: `fulfill` do not trigger an object reassignment,
    /// so no notifications about it can be triggered. It is recommended
    /// to call the method `notify` afterwards.
    public func fulfill(_ value: T) -> Self

    /// - Note: `reject` do not trigger an object reassignment,
    /// so no notifications about it can be triggered. It is recommended
    /// to call the method `notify` afterwards.
    public func reject(_ error: Error) -> Self

    /// Resolves the current `Promise` with the optional `Result` parameter.
    /// - Returns: `self` or `nil` if no `result` was not provided.
    /// - Note: The optional parameter and restun value are helpers in order to
    /// make optional chaining in the `Reducer` context.
    public func resolve(_ result: Result<T, Error>?) -> Self?

    public subscript<T>(dynamicMember member: String) -> T?
}

extension Promise {
    /**
     - Returns: `true` if the promise has not yet resolved nor pending.
     */
    public var isIdle: Bool { get }

    /**
     - Returns: `true` if the promise has not yet resolved.
     */
    public var isPending: Bool { get }

    /**
     - Returns: `true` if the promise has completed.
     */
    public var isCompleted: Bool { get }

    /**
     - Returns: `true` if the promise has resolved.
     */
    public var isResolved: Bool { get }

    /**
     - Returns: `true` if the promise was fulfilled.
     */
    public var isFulfilled: Bool { get }

    /**
     - Returns: `true` if the promise was rejected.
     */
    public var isRejected: Bool { get }

    /**
     - Returns: The value with which this promise was fulfilled or `nil` if this promise is pending or rejected.
     */
    public var value: T? { get }

    /**
     - Returns: The error with which this promise was rejected or `nil` if this promise is pending or fulfilled.
     */
    public var error: Error? { get }
}

extension Promise where T == () {
    public convenience init()

    public static func empty() -> Mini.Promise<T>
}

extension Promise: Equatable where T == () {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Mini.Promise<T>, rhs: Mini.Promise<T>) -> Bool
}

extension Promise where T: Equatable {
    public static func == (lhs: Mini.Promise<T>, rhs: Mini.Promise<T>) -> Bool
}

extension Promise {
    public func notify<T>(to store: T) where T: Mini.StoreType
}

public protocol PromiseType {
    associatedtype Element

    var result: Result<Self.Element, Error>? { get }

    var isIdle: Bool { get }

    var isPending: Bool { get }

    var isResolved: Bool { get }

    var isFulfilled: Bool { get }

    var isRejected: Bool { get }

    var value: Self.Element? { get }

    var error: Error? { get }

    func resolve(_ result: Result<Self.Element, Error>?) -> Self?

    func fulfill(_ value: Self.Element) -> Self

    func reject(_ error: Error) -> Self
}

public enum Promises {}

extension Promises {
    public enum Lifetime {
        case once

        case forever(ignoringOld: Bool)
    }
}

/**
 The `Reducer` defines the behavior to be executed when a certain
 `Action` object is received.
 */
public class Reducer<A>: RxSwift.Disposable where A: Mini.Action {
    /// The `Action` type which the `Reducer` listens to.
    public let action: A.Type

    /// The `Dispatcher` object that sends the `Action` objects.
    public let dispatcher: Mini.Dispatcher

    /// The behavior to be executed when the `Dispatcher` sends a certain `Action`
    public let reducer: (A) -> Void

    /**
     Initializes a new `Reducer` object.
     - Parameter action: The `Action` type that will be listened to.
     - Parameter dispatcher: The `Dispatcher` that sends the `Action`.
     - Parameter reducer: The closure that will be executed when the `Dispatcher`
     sends the defined `Action` type.
     */
    public init(of action: A.Type, on dispatcher: Mini.Dispatcher, reducer: @escaping (A) -> Void)

    /// Dispose resource.
    public func dispose()
}

public class ReducerGroup: Mini.Group {
    public let disposeBag: RxSwift.CompositeDisposable

    public init(_ builder: RxSwift.Disposable...)

    /// Dispose resource.
    public func dispose()
}

public final class RootChain: Mini.Chain {
    public var proceed: Mini.Next { get }

    public init(map: Mini.SubscriptionMap)
}

public protocol Service {
    var id: UUID { get }

    var perform: Mini.ServiceChain { get }
}

public typealias ServiceChain = (Mini.Action, Mini.Chain) -> Void

/// Wrapper class to allow pass dictionaries with a memory reference
public class SharedDictionary<Key, Value> where Key: Hashable {
    public var innerDictionary: [Key: Value]

    public init()

    public func getOrPut(_ key: Key, defaultValue: @autoclosure () -> Value) -> Value

    public func get(withKey key: Key) -> Value?

    public subscript(_: Key, orPut _: @autoclosure () -> Value) -> Value { get }

    public subscript(_: Key) -> Value? { get }
}

public protocol StateType {
    func isEqual(to other: Mini.StateType) -> Bool
}

extension StateType where Self: Equatable {
    public func isEqual(to other: Mini.StateType) -> Bool
}

public class Store<State, StoreController>: RxSwift.ObservableType, Mini.StoreType where State: Mini.StateType, StoreController: RxSwift.Disposable {
    /// Type of elements in sequence.
    public typealias Element = State

    public typealias State = State

    public typealias StoreController = StoreController

    public typealias ObjectWillChangePublisher = RxSwift.BehaviorSubject<State>

    public var objectWillChange: RxSwift.BehaviorSubject<State>

    public let dispatcher: Mini.Dispatcher

    public var storeController: StoreController

    public var state: State

    public var initialState: State { get }

    public init(_ state: State, dispatcher: Mini.Dispatcher, storeController: StoreController)

    public var reducerGroup: Mini.ReducerGroup { get }

    public func notify()

    public func replayOnce()

    public func reset()

    /**
     Subscribes `observer` to receive events for this sequence.

     ### Grammar

     **Next\* (Error | Completed)?**

     * sequences can produce zero or more elements so zero or more `Next` events can be sent to `observer`
     * once an `Error` or `Completed` event is sent, the sequence terminates and can't produce any other elements

     It is possible that events are sent from different threads, but no two events can be sent concurrently to
     `observer`.

     ### Resource Management

     When sequence sends `Complete` or `Error` event all internal resources that compute sequence elements
     will be freed.

     To cancel production of sequence elements and free resources immediately, call `dispose` on returned
     subscription.

     - returns: Subscription for `observer` that can be used to cancel production of sequence elements and free resources.
     */
    public func subscribe<Observer>(_ observer: Observer) -> RxSwift.Disposable where State == Observer.Element, Observer: RxSwift.ObserverType
}

public protocol StoreType {
    associatedtype State: Mini.StateType

    associatedtype StoreController: RxSwift.Disposable

    var state: Self.State { get set }

    var dispatcher: Mini.Dispatcher { get }

    var reducerGroup: Mini.ReducerGroup { get }

    func replayOnce()
}

extension StoreType {
    /**
     Property responsible of reduce the `State` given a certain `Action` being triggered.
     ```
     public var reducerGroup: ReducerGroup {
        ReducerGroup {[
            Reducer(of: SomeAction.self, on: self.dispatcher) { (action: SomeAction)
                self.state = myCoolNewState
            },
            Reducer(of: OtherAction.self, on: self.dispatcher) { (action: OtherAction)
                // Needed work
                self.state = myAnotherState
                }
            }
        ]}
     ```
     - Note : The property has a default implementation which complies with the @_functionBuilder's current limitations, where no empty blocks can be produced in this iteration.
     */
    public var reducerGroup: Mini.ReducerGroup { get }
}

public typealias SubscriptionMap = Mini.SharedDictionary<String, Mini.OrderedSet<Mini.DispatcherSubscription>?>

extension Dictionary {
    /// Returns the value for the given key. If the key is not found in the map, calls the `defaultValue` function,
    /// puts its result into the map under the given key and returns it.
    public mutating func getOrPut(_ key: Key, defaultValue: @autoclosure () -> Value) -> Value

    public subscript(_: Key, orPut _: @autoclosure () -> Value) -> Value { mutating get }

    public subscript(unwrapping _: Key) -> Value! { get }
}

extension Dictionary where Value: Mini.PromiseType {
    public subscript(promise _: Key) -> Value { get }

    public func hasValue(for key: [Key: Value].Key) -> Bool

    public func resolve(with other: [Key: Value]) -> [Key: Value]

    public func mergingNew(with other: [Key: Value]) -> [Key: Value]
}

extension Dictionary where Value: Mini.PromiseType, Value.Element: Equatable {
    public static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool
}

extension DispatchQueue {
    public static var isMain: Bool { get }
}

extension ObservableType {
    /// Take the first element that matches the filter function.
    ///
    /// - Parameter fn: Filter closure.
    /// - Returns: The first element that matches the filter.
    public func filterOne(_ condition: @escaping (Self.Element) -> Bool) -> RxSwift.Observable<Self.Element>
}

extension ObservableType where Self.Element: Mini.StoreType, Self.Element: RxSwift.ObservableType, Self.Element.Element == Self.Element.State {
    public static func dispatch<A, Type, T>(using dispatcher: Mini.Dispatcher, factory action: @autoclosure @escaping () -> A, taskMap: @escaping (Self.Element.State) -> T?, on store: Self.Element, lifetime: Mini.Promises.Lifetime = .once) -> RxSwift.Observable<Self.Element.State> where A: Mini.Action, T: Mini.Promise<Type>

    public static func dispatch<A, K, Type, T>(using dispatcher: Mini.Dispatcher, factory action: @autoclosure @escaping () -> A, key: K, taskMap: @escaping (Self.Element.State) -> [K: T], on store: Self.Element, lifetime: Mini.Promises.Lifetime = .once) -> RxSwift.Observable<Self.Element.State> where A: Mini.Action, K: Hashable, T: Mini.Promise<Type>
}

extension PrimitiveSequenceType where Self: RxSwift.ObservableConvertibleType, Self.Trait == RxSwift.SingleTrait {
    public func dispatch<A>(action: A.Type, on dispatcher: Mini.Dispatcher, mode: Mini.Dispatcher.DispatchMode.UI = .async, fillOnError errorPayload: A.Payload? = nil) -> RxSwift.Disposable where A: Mini.CompletableAction, Self.Element == A.Payload

    public func dispatch<A>(action: A.Type, key: A.Key, on dispatcher: Mini.Dispatcher, mode: Mini.Dispatcher.DispatchMode.UI = .async, fillOnError errorPayload: A.Payload? = nil) -> RxSwift.Disposable where A: Mini.KeyedCompletableAction, Self.Element == A.Payload

    public func action<A>(_ action: A.Type, fillOnError errorPayload: A.Payload? = nil) -> RxSwift.Single<A> where A: Mini.CompletableAction, Self.Element == A.Payload
}

extension PrimitiveSequenceType where Self.Element == Never, Self.Trait == RxSwift.CompletableTrait {
    public func dispatch<A>(action: A.Type, on dispatcher: Mini.Dispatcher, mode: Mini.Dispatcher.DispatchMode.UI = .async) -> RxSwift.Disposable where A: Mini.EmptyAction

    public func action<A>(_ action: A.Type) -> RxSwift.Single<A> where A: Mini.EmptyAction
}
