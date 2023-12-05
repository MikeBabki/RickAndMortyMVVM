//
//  DetailHeroViewModel.swift
//  mvvmRickAndMorty
//
//  Created by Макар Тюрморезов on 02.12.2023.
//

import Foundation

final class DetailHeroViewModel: ObservableObject {
    
    // MARK: - Public properties
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(CharactersModel)
        case error
    }
    
    enum Event {
        case onAppear
    }
    
    // MARK: - Private properties
    
    private let service: NetworkManager
    private var name: String?
    var data: [CharacterSet]? = []
    @Published private(set) var state: State = .idle
    
    // MARK: - Init
    
    init(name: String?, service: NetworkManager) {
        self.name = name
        self.service = service
    }
    
    // MARK: - Public methods
    
    func send(event: Event) {
        switch event {
        case .onAppear:
            loadCharName()
        }
    }
}

extension DetailHeroViewModel {
    func loadCharName() {
        self.state = .loading
        self.service.getCharName(name: self.name ?? "") { (searchResponse) in
            switch searchResponse {
            case .success(let data):
                guard let data = data else { return }
                self.data?.append(contentsOf: data.results ?? [])
                self.state = .loaded(data)
            case .failure(_):
                self.state = .error
                print("Error")
            }
        }
    }
}

