//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 01.08.2023.
//

import Foundation

enum FeedViewModelAction {
    case pushAction
    case checkWordAtion
}

final class FeedViewModel {
    
    enum State {
        case pushButtonAction
        case checkWordButtonAction(String)
    }
    
    var checkWord: String = ""
    var stateChanged: ((State?) -> Void)?

    private(set) var state: State? {
        didSet {
            stateChanged?(state)
        }
    }
    
    func changeAction(_ action: FeedViewModelAction) {
        switch action {
        case .pushAction:
            state = .pushButtonAction
        case .checkWordAtion:
            state = .checkWordButtonAction(checkWord)
        }
    }
}
