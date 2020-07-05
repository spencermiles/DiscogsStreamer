import Combine

extension Publisher {
    /// Changes a publisher of type Publisher<Output, Failure> to AnyPublisher<Result<Output, Failure>, Never>
    /// 
    /// **Note** The resulting publisher only produces a single value, even if the original publisher would have produced multiple values.
    func resultify() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.first()
            .map { .success($0) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}

//extension Publisher where Failure == Never {
//    /// By default, assign creates a strong reference to Root.
//    /// This will break that cycle without the overhead of sinking yourself.
//    func assignWeakly<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>,
//                            on object: Root) -> AnyCancellable
//    {
//        sink { [weak object] in
//            object?[keyPath: keyPath] = $0
//        }
//    }
//}
