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
            NavigationView {
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: BlackjackSettings().environmentObject(game)) {
                                Image(systemName: "gear")
                            }
                            .padding(.top)
                        }
                        .padding()
                    }
                    .frame(width: geometry.size.width, height: 0)
                    VStack {
                        ZStack {
                            ForEach(0..<game.dealerHand.count, id: \.self) { id in
                                Image(uiImage: UIImage(named: game.deck_path + game.dealerHand[id])!)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: geometry.size.height * 0.4, height: geometry.size.height * 0.4)
                                    .offset(x: geometry.size.width * (-0.2 + (0.12 * CGFloat(id))), y: 0)
                                    .shadow(color: Color.black, radius: 10)
                            }
                            if game.show_count {
                                Text("\(game.getScore(player: false))")
                                    .offset(x: geometry.size.width * -0.475, y: 0)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.45, alignment: .center)
                    VStack {
                        ZStack {
                            ForEach(0..<game.playerHand.count, id: \.self) { id in
                                Image(uiImage: UIImage(named: game.deck_path + game.playerHand[id])!)
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: geometry.size.height * 0.4, height: geometry.size.height * 0.4)
                                    .offset(x: geometry.size.width * (-0.2 + (0.12 * CGFloat(id))), y: 0)
                                    .shadow(color: Color.black, radius: 10)
                            }
                            if game.show_count {
                                Text("\(game.getScore(player: true))")
                                    .offset(x: geometry.size.width * -0.475, y: 0)
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
                                    game.stand()
                                }) {
                                    Image(uiImage: UIImage(named: "buttons/stand")!)
                                        .resizable()
                                        .interpolation(.none)
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                                }
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
                            } else {
                                ZStack {
                                    Button(action: {
                                        game.dealCards()
                                        game.gameOver = false
                                    }) {
                                        Image(uiImage: UIImage(named: "buttons/deal")!)
                                            .resizable()
                                            .interpolation(.none)
                                            .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                                    }
                                    if game.gameOver {
                                        Label(game.gameResult.1, systemImage: game.gameResult.0 == 0 ? "xmark.circle" : game.gameResult.0 == 1 ? "crown" : "equal.circle")
                                            .offset(x: 0, y: geometry.size.width * -0.125)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.1, alignment: .bottom)
                }
            }
        }
    }
}

#Preview {
    BlackjackTable()
}
