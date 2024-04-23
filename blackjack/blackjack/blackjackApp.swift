//
//  blackjackApp.swift
//  blackjack
//
//  Created by Jayen Agrawal on 2/29/24.
//

import SwiftUI
import GameKit

@main
struct blackjackApp: App {
    @StateObject private var state = BlackjackGame()
    let settingsManager = SettingsManager.shared
    
    init() {
        self.state.gameCenterOk = true
        self.gameCenter()
    }
    
    var body: some Scene {
        WindowGroup {
            BlackjackTable()
                .preferredColorScheme(.dark)
                .environmentObject(state)
        }
    }
    
    func gameCenter() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if error != nil {
                state.gameCenterOk = false
            }
            state.gameCenterOk = true
        }
    }
}
