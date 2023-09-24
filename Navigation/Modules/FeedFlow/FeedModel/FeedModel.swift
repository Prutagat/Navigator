//
//  FeedModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 29.07.2023.
//

import Foundation

final class FeedModel {
    
    private let secretWord = "Donald"
    
    func check(word: String) throws -> Bool {
        if secretWord == word {
            return true
        } else if word == "" {
            throw ApiError.isEmpty
        } else if secretWord != word {
            throw ApiError.unauthorized
        } else {
            throw ApiError.notFound
        }
    }
}
