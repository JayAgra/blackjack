//
//  BlackjackGame.swift
//  blackjack
//
//  Created by Jayen Agrawal on 3/21/24.
//

import Foundation
import GameKit

class BlackjackGame: ObservableObject {
    @Published public var gameCenterOk: Bool = true
    
    @Published public var winScreen: Bool = false
    @Published public var gameResult: (Int, String) = (3, "Error")
    @Published public var gameOver: Bool = false
    
    @Published public var show_count: Bool = UserDefaults.standard.bool(forKey: "show_count")
    @Published public var deck_path: String = UserDefaults.standard.string(forKey: "deck_type") ?? "cards"
    
    @Published public var dealerHand: [String] = ["/card_back"]
    @Published public var playerHand: [String] = ["/card_back", "/card_back"]
    @Published public var dealt: Bool = false
    
    private var dealerValues: [String] = []
    private var playerValues: [String] = []
    
    private let suits: [String] = ["h", "d", "c", "s"]
    private let values: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    
    public func dealCards() {
        if !dealt {
            dealerValues = []
            playerValues = []
            dealerHand = [pickCard(player: false)]
            playerHand = [pickCard(player: true), pickCard(player: true)]
            dealt = true
            if getScore(player: true) >= 21 {
                gameResult = endGame()
                winScreen = true
            }
        }
    }
    
    public func hit() {
        guard gameOver else {
            playerHand.append(pickCard(player: true))
            if getScore(player: true) >= 21 {
                gameResult = endGame()
                winScreen = true
            }
            return
        }
    }
    
    public func stand() {
        guard gameOver else {
            while getScore(player: false) < 17 {
                dealerHand.append(pickCard(player: false))
            }
            gameResult = endGame()
            winScreen = true
            return
        }
    }
    
    private func pickCard(player: Bool) -> String {
        let value: String = values.randomElement() ?? "2"
        if player {
            playerValues.append(value)
        } else {
            dealerValues.append(value)
        }
        return "/card-" + (suits.randomElement() ?? "c") + "_" + value
    }
    
    public func getScore(player: Bool) -> Int {
        var score: Int = 0
        var aces: Int = 0
        let values: [String] = player ? playerValues : dealerValues
        
        values.forEach { value in
            switch value {
            case "A":
                aces += 1
                score += 11
                break
            case "K":
                score += 10
                break
            case "Q":
                score += 10
                break
            case "J":
                score += 10
                break
            default:
                score += Int(value) ?? 0
            }
        }
        
        while aces > 0 && score > 21 {
            score -= 10
            aces -= 1
        }
        
        return score
    }
    
    private func endGame() -> (Int, String) {
        var result: String = ""
        // 0 = loss, 1 = win, 2 = draw, 3 = no result
        var gameResult: Int = 0
        let playerScore: Int = getScore(player: true)
        let dealerScore: Int = getScore(player: false)
        
        if playerScore > 21 {
            result = "loss - bust"
            if gameCenterOk {
                GKLeaderboard.loadLeaderboards(IDs: ["com.jayagra.blackjack.win_leaderboard"], completionHandler: { leaderboard, error in
                    leaderboard?.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { leaderboardEntry, leaderboardEntries, error in
                        if leaderboardEntry != nil {
                            leaderboard?.first?.submitScore((leaderboardEntry?.score ?? 0) - 1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        } else {
                            leaderboard?.first?.submitScore(-1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        }
                    })
                })
            }
        } else if dealerScore > 21 {
            result = "win - dealer bust"
            gameResult = 1
            if gameCenterOk {
                GKLeaderboard.loadLeaderboards(IDs: ["com.jayagra.blackjack.win_leaderboard"], completionHandler: { leaderboard, error in
                    leaderboard?.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { leaderboardEntry, leaderboardEntries, error in
                        if leaderboardEntry != nil {
                            leaderboard?.first?.submitScore((leaderboardEntry?.score ?? 0) + 1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        } else {
                            leaderboard?.first?.submitScore(1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        }
                    })
                })
            }
        } else if playerScore > dealerScore {
            result = "win"
            gameResult = 1
            if gameCenterOk {
                GKLeaderboard.loadLeaderboards(IDs: ["com.jayagra.blackjack.win_leaderboard"], completionHandler: { leaderboard, error in
                    leaderboard?.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { leaderboardEntry, leaderboardEntries, error in
                        if leaderboardEntry != nil {
                            leaderboard?.first?.submitScore((leaderboardEntry?.score ?? 0) + 1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        } else {
                            leaderboard?.first?.submitScore(1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        }
                    })
                })
            }
        } else if dealerScore > playerScore {
            result = "loss"
            if gameCenterOk {
                GKLeaderboard.loadLeaderboards(IDs: ["com.jayagra.blackjack.win_leaderboard"], completionHandler: { leaderboard, error in
                    leaderboard?.first?.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { leaderboardEntry, leaderboardEntries, error in
                        if leaderboardEntry != nil {
                            leaderboard?.first?.submitScore((leaderboardEntry?.score ?? 0) - 1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        } else {
                            leaderboard?.first?.submitScore(-1, context: 0, player: GKLocalPlayer.local, completionHandler: {_ in })
                        }
                    })
                })
            }
        } else {
            result = "draw"
            gameResult = 2
        }
        
        gameOver = true
        dealt = false
        return (gameResult, result)
    }
}
