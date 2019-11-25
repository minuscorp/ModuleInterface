import Mini

/// Protocol that has to be conformed by any object that can be dispatcher
/// by a `Dispatcher` object.
public protocol Action {
    /// Equality function between `Action` objects
    /// - Returns: If an `Action` is the same as other.
    func isEqual(to other: Action) -> Bool
}

/// The `Reducer` defines the behavior to be executed when a certain
/// `Action` object is received.
public class Reducer<A: Action>: Disposable {
    /// The `Action` type which the `Reducer` listens to.
    public let action: A.Type

    /// The `Dispatcher` object that sends the `Action` objects.
    public let dispatcher: Dispatcher

    /// The behavior to be executed when the `Dispatcher` sends a certain `Action`
    public let reducer: (A) -> Void

    /// Initializes a new `Reducer` object.
    /// - Parameter action: The `Action` type that will be listened to.
    /// - Parameter dispatcher: The `Dispatcher` that sends the `Action`.
    /// - Parameter reducer: The closure that will be executed when the `Dispatcher`
    /// sends the defined `Action` type.
    public init(of action: A.Type, on dispatcher: Dispatcher, reducer: @escaping (A) -> Void)

    /// Dispose resource.
    public func dispose()
}

public typealias SubscriptionMap = SharedDictionary<String, OrderedSet<DispatcherSubscription>?>

public final class Dispatcher {
    public struct DispatchMode {
        public enum UI {
            case sync
            case async
        }
    }

    public var subscriptionCount: Int

    public static let defaultPriority = 100

    public init()

    public func add(middleware: Middleware)

    public func remove(middleware: Middleware)

    public func register(service: Service)

    public func unregister(service: Service)

    public func subscribe(priority: Int, tag: String, completion: @escaping (Action) -> Void) -> DispatcherSubscription

    public func registerInternal(subscription: DispatcherSubscription) -> DispatcherSubscription

    public func unregisterInternal(subscription: DispatcherSubscription)

    public func subscribe<T: Action>(completion: @escaping (T) -> Void) -> DispatcherSubscription

    public func subscribe<T: Action>(tag: String, completion: @escaping (T) -> Void) -> DispatcherSubscription

    public func subscribe(tag: String, completion: @escaping (Action) -> Void) -> DispatcherSubscription

    public func dispatch(_ action: Action, mode: Dispatcher.DispatchMode.UI)
}

public final class DispatcherSubscription: Comparable, Disposable {
    public let id: Int

    public let tag: String

    public init(dispatcher: Dispatcher,
                id: Int,
                priority: Int,
                tag: String,
                completion: @escaping (Action) -> Void)

    public func dispose()

    public func on(_ action: Action)

    public static func == (lhs: DispatcherSubscription, rhs: DispatcherSubscription) -> Bool

    public static func > (lhs: DispatcherSubscription, rhs: DispatcherSubscription) -> Bool

    public static func < (lhs: DispatcherSubscription, rhs: DispatcherSubscription) -> Bool

    public static func >= (lhs: DispatcherSubscription, rhs: DispatcherSubscription) -> Bool

    public static func <= (lhs: DispatcherSubscription, rhs: DispatcherSubscription) -> Bool
}

public typealias MiddlewareChain = (Action, Chain) -> Action

public typealias Next = (Action) -> Action

public protocol Chain {
    var proceed: Next
}

public protocol Middleware {
    var id: UUID

    var perform: MiddlewareChain
}

public final class ForwardingChain: Chain {
    public var proceed: Next

    public init(next: @escaping Next)
}

public final class RootChain: Chain {
    public var proceed: Next

    public init(map: SubscriptionMap)
}

public protocol PromiseType {
    associatedtype Element

    var result: Result<Element, Swift.Error>?

    var isIdle: Bool

    var isPending: Bool

    var isResolved: Bool

    var isFulfilled: Bool

    var isRejected: Bool

    var value: Element?

    var error: Swift.Error?

    func resolve(_ result: Result<Element, Swift.Error>?) -> Self?

    func fulfill(_ value: Element) -> Self

    func reject(_ error: Swift.Error) -> Self
}

public final class Promise<T>: PromiseType {
    public typealias Element = T

    public class func value(_ value: T) -> Promise<T>

    public class func error(_ error: Swift.Error) -> Promise<T>

    public init(error: Swift.Error)

    public init()

    public class func idle(with options: [String: Any] = [:]) -> Promise<T>

    public class func pending(options: [String: Any] = [:]) -> Promise<T>

    public var result: Result<T, Swift.Error>?

    /// - Note: `fulfill` do not trigger an object reassignment,
    /// so no notifications about it can be triggered. It is recommended
    /// to call the method `notify` afterwards.
    public func fulfill(_ value: T) -> Self

    /// - Note: `reject` do not trigger an object reassignment,
    /// so no notifications about it can be triggered. It is recommended
    /// to call the method `notify` afterwards.
    public func reject(_ error: Swift.Error) -> Self

    /// Resolves the current `Promise` with the optional `Result` parameter.
    /// - Returns: `self` or `nil` if no `result` was not provided.
    /// - Note: The optional parameter and restun value are helpers in order to
    /// make optional chaining in the `Reducer` context.
    public func resolve(_ result: Result<T, Error>?) -> Self?

    public subscript<T>(dynamicMember member: String) -> T?
}

public extension Promise {
    /// - Returns: `true` if the promise has not yet resolved nor pending.
    var isIdle: Bool

    /// - Returns: `true` if the promise has not yet resolved.
    var isPending: Bool

    /// - Returns: `true` if the promise has completed.
    var isCompleted: Bool

    /// - Returns: `true` if the promise has resolved.
    var isResolved: Bool

    /// - Returns: `true` if the promise was fulfilled.
    var isFulfilled: Bool

    /// - Returns: `true` if the promise was rejected.
    var isRejected: Bool

    /// - Returns: The value with which this promise was fulfilled or `nil` if this promise is pending or rejected.
    var value: T?

    /// - Returns: The error with which this promise was rejected or `nil` if this promise is pending or fulfilled.
    var error: Swift.Error?
}

public protocol Group: Disposable {
    var disposeBag: CompositeDisposable
}

public class ReducerGroup: Group {
    public let disposeBag = CompositeDisposable()

    public init(_ builder: Disposable...)

    public func dispose()
}

public typealias ServiceChain = (Action, Chain) -> Void

public protocol Service {
    var id: UUID

    var perform: ServiceChain
}

public protocol StateType {
    func isEqual(to other: StateType) -> Bool
}

public extension StateType where Self: Equatable {
    func isEqual(to other: StateType) -> Bool
}

public extension Promise {
    func notify<T: StoreType>(to store: T)
}

public protocol StoreType {
    associatedtype State: StateType

    associatedtype StoreController: Disposable

    var state: State

    var dispatcher: Dispatcher

    var reducerGroup: ReducerGroup

    func replayOnce()
}

public class Store<State: StateType, StoreController: Disposable>: ObservableType, StoreType {
    public typealias Element = State

    public typealias State = State

    public typealias StoreController = StoreController

    public typealias ObjectWillChangePublisher = BehaviorSubject<State>

    public var objectWillChange: ObjectWillChangePublisher

    public let dispatcher: Dispatcher

    public var storeController: StoreController

    public var state: State

    public var initialState: State

    public init(_ state: State,
                dispatcher: Dispatcher,
                storeController: StoreController)

    public var reducerGroup: ReducerGroup

    public func notify()

    public func replayOnce()

    public func reset()

    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Store.Element
}

public extension Dictionary where Value: PromiseType, Key: Hashable, Value.Element: Equatable {
    static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool
}

public extension DispatchQueue {
    static var isMain: Bool
}

/// An Ordered Set is a collection where all items in the set follow an ordering,
/// usually ordered from 'least' to 'most'. The way you value and compare items
/// can be user-defined.
public class OrderedSet<T: Comparable> {
    public init(initial: [T] = [])

    /// Returns the number of elements in the OrderedSet.
    public var count: Int

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
    public subscript(index: Int) -> T

    /// Returns the 'maximum' or 'largest' value in the set.
    public var max: T?

    /// Returns the 'minimum' or 'smallest' value in the set.
    public var min: T?

    /// Returns the k-th largest element in the set, if k is in the range
    /// [1, count]. Returns nil otherwise.
    public func kLargest(element: Int) -> T?

    /// Returns the k-th smallest element in the set, if k is in the range
    /// [1, count]. Returns nil otherwise.
    public func kSmallest(element: Int) -> T?

    /// For each function
    public func forEach(_ body: (T) -> Swift.Void)

    /// Enumerated function
    public func enumerated() -> EnumeratedSequence<[T]>
}

public protocol PayloadAction {
    associatedtype Payload

    init(promise: Promise<Payload>)
}

public protocol CompletableAction: Action & PayloadAction

public protocol EmptyAction: Action & PayloadAction where Payload == Swift.Void {
    init(promise: Promise<Void>)
}

public extension EmptyAction {
    init(promise _: Promise<Payload>)
}

public protocol KeyedPayloadAction {
    associatedtype Payload

    associatedtype Key: Hashable

    init(promise: [Key: Promise<Payload>])
}

public protocol KeyedCompletableAction: Action & KeyedPayloadAction

public enum Promises

public extension Promises {
    enum Lifetime {
        case once
        case forever(ignoringOld:)
    }
}

public extension PrimitiveSequenceType where Self: ObservableConvertibleType, Self.Trait == SingleTrait {
    func dispatch<A: CompletableAction>(action: A.Type,
                                        on dispatcher: Dispatcher,
                                        mode: Dispatcher.DispatchMode.UI = .async,
                                        fillOnError errorPayload: A.Payload? = nil)
        -> Disposable where A.Payload == Self.Element

    func dispatch<A: KeyedCompletableAction>(action: A.Type,
                                             key: A.Key,
                                             on dispatcher: Dispatcher,
                                             mode: Dispatcher.DispatchMode.UI = .async,
                                             fillOnError errorPayload: A.Payload? = nil)
        -> Disposable where A.Payload == Self.Element

    func action<A: CompletableAction>(_ action: A.Type,
                                      fillOnError errorPayload: A.Payload? = nil)
        -> Single<A> where A.Payload == Self.Element
}

public extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    func dispatch<A: EmptyAction>(action: A.Type,
                                  on dispatcher: Dispatcher,
                                  mode: Dispatcher.DispatchMode.UI = .async)
        -> Disposable

    func action<A: EmptyAction>(_ action: A.Type)
        -> Single<A>
}

/// Wrapper class to allow pass dictionaries with a memory reference
public class SharedDictionary<Key: Hashable, Value> {
    public var innerDictionary: [Key: Value]

    public init()

    public func getOrPut(_ key: Key, defaultValue: @autoclosure () -> Value) -> Value

    public func get(withKey key: Key) -> Value?

    public subscript(_ key: Key, orPut defaultValue: @autoclosure () -> Value) -> Value

    public subscript(_ key: Key) -> Value?
}
