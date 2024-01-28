//
//  Localized.swift
//  Navigation
//
//  Created by Алексей Голованов on 28.01.2024.
//

import Foundation

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}
