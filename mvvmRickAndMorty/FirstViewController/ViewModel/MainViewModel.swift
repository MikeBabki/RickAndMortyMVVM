//
//  MainViewModel.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 30.11.2023.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    // MARK: - State
    
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case error
    }
    
    // MARK: - Event's
    
    enum Event: Equatable {
        case onAppear
        case nextPage
        case onDetailScreen(Int)
    }
    
    // MARK: - Private propetries
    
    @Published private(set) var state = State.idle
    private let service: NetworkManager
    private var coordinatorController: MainFlowController?
    
    // MARK: - Public propetries
    
    var pageNumber = 1
    var data: [CharacterSet]? = []
    var pagesNum = CharactersModel()
    
    // MARK: - Init
    
    init(service: NetworkManager, coordinatorController: MainFlowController) {
        self.service = service
        self.coordinatorController = coordinatorController
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        switch event {
        case .onAppear:
            state = .loading
            loadData()
        case .nextPage:
            state = .loading
            loadData()
        case .onDetailScreen(let index):
            
            coordinatorController?.goToDetailScreen(self.data?[index].name ?? "")
        }
    }
}

// MARK: - Extention for loading data

extension MainViewModel {
    func loadData() {
        self.service.getResult(page: self.pageNumber) { (searchResponse) in
            switch searchResponse {
            case .success(let data):
                guard let data = data else { return }
                self.pageNumber += 1
                self.data?.append(contentsOf: data.results ?? [])
                self.pagesNum = data
                self.state = .loaded
            case .failure(_):
                self.state = .error
            }
        }
    }
}
