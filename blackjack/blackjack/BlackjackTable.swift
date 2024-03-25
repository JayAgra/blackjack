//
//  ContentView.swift
//  blackjack
//
//  Created by Jayen Agrawal on 2/29/24.
//

import SwiftUI

struct BlackjackTable: View {
    @EnvironmentObject public var game: BlackjackGame
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    ZStack {
                        ForEach(0..<game.dealerHand.count, id: \.self) { id in
                            Image(uiImage: UIImage(named: game.dealerHand[id])!)
                                .resizable()
                                .interpolation(.none)
                                .frame(width: geometry.size.height * 0.4, height: geometry.size.height * 0.4)
                                .offset(x: geometry.size.width * (-0.2 + (0.1 * CGFloat(id))), y: 0)
                                .shadow(color: Color.black, radius: 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.45, alignment: .center)
                VStack {
                    ZStack {
                        ForEach(0..<game.playerHand.count, id: \.self) { id in
                            Image(uiImage: UIImage(named: game.playerHand[id])!)
                                .resizable()
                                .interpolation(.none)
                                .frame(width: geometry.size.height * 0.4, height: geometry.size.height * 0.4)
                                .offset(x: geometry.size.width * (-0.2 + (0.1 * CGFloat(id))), y: 0)
                                .shadow(color: Color.black, radius: 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.45, alignment: .center)
                VStack {
                    Spacer()
                    HStack {
                        if game.dealt && !game.gameOver {
                            Spacer()
                            Button(action: {
                                game.hit()
                            }) {
                                Image(uiImage: UIImage(named: "buttons/hit")!)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                            }
                            Spacer()
                            Button(action: {
                                game.stand()
                            }) {
                                Image(uiImage: UIImage(named: "buttons/stand")!)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                            }
                            Spacer()
                        } else {
                            Spacer()
                            Button(action: {
                                game.dealCards()
                                game.gameOver = false
                            }) {
                                Image(uiImage: UIImage(named: "buttons/deal")!)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.1, alignment: .bottom)
            }
        }
        .padding()
        .alert(
            isPresented: $game.winScreen,
            content: {
                Alert(
                    title: Text(game.gameResult.0 == 0 ? "Loss" : game.gameResult.0 == 1 ? "Win" : "Draw"),
                    message: Text(game.gameResult.1),
                    dismissButton: .default(Text("ok"))
                )
            })
    }
}

#Preview {
    BlackjackTable()
}
