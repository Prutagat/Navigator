//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 01.08.2023.
//

import Foundation

final class FeedViewModel {
    
    enum Action {
        case pushAction
        case checkWordAtion
    }
    
    enum State {
        case pushButtonAction
        case checkWordButtonAction(String)
    }
    
    var checkWord: String = ""
    var stateChanged: ((State?) -> Void)?

//    private let fetchService: FetchService
//    private let coordinator: FirstFlowCoordinator
    private(set) var state: State? {
        didSet {
            stateChanged?(state)
        }
    }
    
    func changeAction(_ action: Action) {
        switch action {
        case .pushAction:
            state = .pushButtonAction
        case .checkWordAtion:
            state = .checkWordButtonAction(checkWord)
        }
    }
    
//
//    init(fetchService: FetchService,
//         coordinator: FirstFlowCoordinator
//    ) {
//        self.fetchService = fetchService
//        self.coordinator = coordinator
//    }
//
//    func changeAction(_ action: Action) {
//        switch action {
//        case .fetchButtonDidTap:
//            state = .loading
//            fetchService.fetchUsers { [weak self] result in
//                switch result {
//                case .success(let users):
//                    print(users)
//                    self?.state = .loaded(users)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self?.state = .error
//                }
//            }
//        case .cellDidTap:
//            coordinator.showDetails()
//        }
//    }
}
