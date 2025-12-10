//
//  SettingsManager.swift
//  blackjack
//
//  Created by Jayen Agrawal on 4/23/24.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() {
        let defaults: [String: Any] = [
            "show_count": true,
            "deck_type": "cards",
            "score": 0
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
}
