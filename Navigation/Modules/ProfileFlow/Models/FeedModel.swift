//
//  FeedModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 29.07.2023.
//

import Foundation

final class FeedModel {
    
    private let secretWord = "Donald"
    
    func check(word: String) -> Bool {
        return secretWord == word
    }
}
