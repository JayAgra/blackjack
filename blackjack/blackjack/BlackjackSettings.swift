//
//  BlackjackSettings.swift
//  blackjack
//
//  Created by Jayen Agrawal on 4/23/24.
//

import SwiftUI
import GameKit

struct BlackjackSettings: View {
    @EnvironmentObject public var game: BlackjackGame
    @State private var show_count: Bool = UserDefaults.standard.bool(forKey: "show_count")
    @State private var deck_type: String = UserDefaults.standard.string(forKey: "deck_type") ?? "cards"
    @State private var gk_score: Int?
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Text("Score")
                        Spacer()
                        Text(String(gk_score ?? UserDefaults.standard.integer(forKey: "score")))
                    }
                }
                Section {
                    Toggle("Show Count", isOn: $show_count)
                        .onChange(of: show_count) { value in
                            UserDefaults.standard.set(show_count, forKey: "show_count")
                            game.show_count = show_count
                        }
                    Picker("Deck Style", selection: $deck_type) {
                        Text("Dark")
                            .tag("cards")
                        Text("Light")
                            .tag("light_cards")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: deck_type) { value in
                        UserDefaults.standard.set(deck_type, forKey: "deck_type")
                        game.deck_path = deck_type
                    }
                }
            }
        }
        .onAppear {
            getScore()
        }
        .navigationTitle("Settings")
    }
    
    private func getScore() {
        GKLeaderboard.loadLeaderboards(IDs: ["com.jayagra.blackjack.win_leaderboard"], completionHandler: { leaderboard, error in
            leaderboard?.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { leaderboardEntry, leaderboardEntries, error in
                gk_score = leaderboardEntry?.score ?? 0
            })
        })
    }
}

#Preview {
    BlackjackSettings()
}
