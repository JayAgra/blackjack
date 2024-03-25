//
//  blackjackApp.swift
//  blackjack
//
//  Created by Jayen Agrawal on 2/29/24.
//

import SwiftUI

@main
struct blackjackApp: App {
    @StateObject private var state = BlackjackGame()
    
    var body: some Scene {
        WindowGroup {
            BlackjackTable()
                .preferredColorScheme(.dark)
                .environmentObject(state)
        }
    }
}
