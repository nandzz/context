import Foundation
import Combine
import SwiftUI

//MARK: - INTERFACE

protocol ContextIdentifier {
    associatedtype Context: ViewContext
    ///Current Context being present
    ///The view on screen
    var current: Context { get }
    var childView: AnyView? { get set }
    init(current: Context)
}

protocol Routable: ObservableObject {
    associatedtype Context: ViewContext
    associatedtype State: ContextState

    var isChildPresented: Bool { get set }
    var childPresentationMode: Presentation { get set }

    var next: CurrentValueSubject<(context: Context, state: State)?, Never> { get }
    var back: CurrentValueSubject<(context: Context, state: State)?, Never> { get }
    var root: CurrentValueSubject<(context: Context, state: State)?, Never> { get }
    var sequential: CurrentValueSubject<(context: Context, state: State)?, Never> { get }
    var onNext: AnyPublisher<(context: Context, state: State)?, Never> { get }
    var onBack: AnyPublisher<(context: Context, state: State)?, Never> { get }
    var onRoot: AnyPublisher<(context: Context, state: State)?, Never> { get }
    func next(emit state: State)
    func back(emit state: State)
    func root(emit state: State)

    /// This Method should be called in onAppear
    func proceedSequencialIfNeeded(emit: State)
}

extension Routable {
    //MARK: CONCRETE ROUTING - OBSERVERS
    var onNext: AnyPublisher<(context: Context, state: State)?, Never> { next.eraseToAnyPublisher() }
    var onBack: AnyPublisher<(context: Context, state: State)?, Never> { back.eraseToAnyPublisher() }
    var onRoot: AnyPublisher<(context: Context, state: State)?, Never> { root.eraseToAnyPublisher() }
    var onSequencial: AnyPublisher<(context: Context, state: State)?, Never> { sequential.eraseToAnyPublisher() }
}

//MARK: - CONCRETE

public class PresentationContext<Context: ViewContext, State: ContextState>: ContextIdentifier, Routable {

    //MARK: CONCRETE CONTEXT - PROPERTIES
    public var current: Context

    var state: State?

    //MARK: CONCRETE ROUTING - SUBJECTS
    internal var next: CurrentValueSubject<(context: Context, state: State)?, Never>
    internal var back: CurrentValueSubject<(context: Context, state: State)?, Never>
    internal var root: CurrentValueSubject<(context: Context, state: State)?, Never>
    internal var sequential: CurrentValueSubject<(context: Context, state: State)?, Never>

    //MARK: CONCRETE ROUTING - ACTIONS FUNCTIONS
    public func next(emit state: State) { next.send((context: current, state: state)) }
    public func back(emit state: State) { back.send((context: current, state: state)) }
    public func root(emit state: State) { root.send((context: current, state: state)) }
    public func proceedSequencialIfNeeded(emit: State) { }

    //MARK: CONCRETE ROUTING - PROPERTIES
    @Published public var isChildPresented: Bool = false
    public var childPresentationMode: Presentation = .push
    public var childView: AnyView?
    
    public required init(current: Context) {
        self.current = current
        self.next = .init(nil)
        self.back = .init(nil)
        self.root = .init(nil)
        self.sequential = .init(nil)
    }
}

