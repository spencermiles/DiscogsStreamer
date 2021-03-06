//
//  BrowserDataSource.swift
//  DiscogsStreamer
//
//  Created by Spencer on 7/5/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import Combine
import Foundation

class BrowserDataSource {
    private let perPage: UInt
    private let service: DiscogsService
    
    @Published private(set) var data = Data()
    
    struct Data {
        var items: [Browseable] = []
        var isLoading: Bool = false
        var isReloading: Bool = false
        var canLoadMore: Bool = false
        var didFail: Bool = false
    }
    
    fileprivate enum State {
        case ready
        case loading(AnyCancellable)
        case loaded([DiscogsService.ReleasesResponse])
        case loadingMore([DiscogsService.ReleasesResponse], AnyCancellable)
    }
    
    private var state: State = .ready {
        didSet {
            deriveData()
        }
    }
    
    init(perPage: UInt, service: DiscogsService) {
        self.perPage = perPage
        self.service = service
        
        self.deriveData()
    }
    
    private func deriveData() {
        self.data = Data(
            items: state.items,
            isLoading: state.isLoading,
            isReloading: state.isLoading,
            canLoadMore: state.canLoadMore,
            didFail: state.didFail)
    }
    
    func loadMore() {
        guard state.canLoadMore && !state.isLoading else {
            return
        }
        
        state.startLoading(task: task(forPage: state.nextPage))
    }
    
    func reload() {
        state.startReloading(task: task(forPage: 1))
    }
    
    private func task(forPage page: UInt) -> AnyCancellable {
        // TODO: Replace this with better values
        let request = DiscogsService.UserReleasesRequest(username: "spencermiles", folderId: 0, page: page)
        
        return service.userReleases(for: request)
            .receive(on: DispatchQueue.main)
            .resultify()
            .sink { [weak self] in self?.handleReleases(result: $0) }
    }
    
    private func handleReleases(result: Result<DiscogsService.ReleasesResponse, Error>) {
        do {
            let releases = try result.get()
            state.recordSuccess(response: releases)
        } catch {
            // TODO: Implement failure
//            state.recordFailure(error: error)
        }
    }
}

private extension BrowserDataSource.State {
    var responses: [DiscogsService.ReleasesResponse] {
        switch self {
        case .loaded(let responses),
             .loadingMore(let responses, _):
            return responses
        case .ready, .loading:
            return []
        }
    }
    
    var items: [Browseable] {
        responses.flatMap { $0.items }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading, .loadingMore:
            return true
        case .ready, .loaded:
            return false
        }
    }
    
    var canLoadMore: Bool {
        switch self {
        case .ready, .loading:
            return true
            
        case .loaded(let responses),
             .loadingMore(let responses, _):
            let page = responses.last?.pagination.page ?? 1
            let pages = responses.last?.pagination.pages ?? 1
            return page < pages
        }
    }
    
    var didFail: Bool {
        return false
    }
    
    var nextPage: UInt {
        switch self {
        case .loaded(let responses),
             .loadingMore(let responses, _):
            guard let page = responses.last?.pagination.page else {
                return 1
            }
            return page + 1
            
        case .ready, .loading:
            return 1
        }
    }
    
    mutating func startLoading(task: AnyCancellable) {
        switch self {
        case .ready, .loading:
            self = .loading(task)
            
        case .loaded(let responses),
             .loadingMore(let responses, _):
            self = .loadingMore(responses, task)
        }
    }
    
    mutating func startReloading(task: AnyCancellable) {
        self = .loading(task)
    }
    
    mutating func recordSuccess(response: DiscogsService.ReleasesResponse) {
        switch self {
        case .ready,
             .loading:
            self = .loaded([response])
            
        case .loaded(let responses),
             .loadingMore(let responses, _):
            self = .loaded(responses + [response])
        }
    }
}
