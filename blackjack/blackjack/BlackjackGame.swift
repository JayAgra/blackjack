//
//  BlackjackGame.swift
//  blackjack
//
//  Created by Jayen Agrawal on 3/21/24.
//

import Foundation

class BlackjackGame: ObservableObject {
    @Published public var winScreen: Bool = false
    @Published public var gameResult: (Int, String) = (3, "Error")
    @Published public var gameOver: Bool = false
    
    @Published public var dealerHand: [String] = ["cards/card_back", "cards/card_back"]
    @Published public var playerHand: [String] = ["cards/card_back", "cards/card_back"]
    @Published public var dealt: Bool = false
    
    private var dealerValues: [String] = []
    private var playerValues: [String] = []
    
    private let suits: [String] = ["h", "d", "c", "s"]
    private let values: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    
    public func dealCards() {
        if !dealt {
            dealerValues = []
            playerValues = []
            dealerHand = [pickCard(player: false), "cards/card_back"]
            playerHand = [pickCard(player: true), pickCard(player: true)]
            dealt = true
            if getScore(player: true) >= 21 {
                gameResult = endGame()
                winScreen = true
            }
        }
    }
    
    public func hit() {
        playerHand.append(pickCard(player: true))
        print(getScore(player: true))
        if getScore(player: true) >= 21 {
            gameResult = endGame()
            winScreen = true
        }
    }
    
    public func stand() {
        while getScore(player: false) < 17 {
            if dealerHand.count == 2 {
                dealerHand[1] = pickCard(player: false)
            } else {
                dealerHand.append(pickCard(player: false))
            }
        }
        gameResult = endGame()
        winScreen = true
    }
    
    private func pickCard(player: Bool) -> String {
        let value: String = values.randomElement() ?? "2"
        if player {
            playerValues.append(value)
        } else {
            dealerValues.append(value)
        }
        return "cards/card-" + (suits.randomElement() ?? "c") + "_" + value
    }
    
    private func getScore(player: Bool) -> Int {
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
            result = "Bust"
        } else if dealerScore > 21 {
            result = "Dealer bust"
            gameResult = 1
        } else if playerScore > dealerScore {
            result = "You won"
            gameResult = 1
        } else if dealerScore > playerScore {
            result = "You lost"
        } else {
            result = "Draw"
            gameResult = 2
        }
        
        gameOver = true
        dealt = false
        return (gameResult, result)
    }
}
