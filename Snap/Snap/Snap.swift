//
//  Snap.swift
//  Snap
//
//  Created by Bhumeshwer KATRE on 9/9/19.
//  Copyright © 2019 Bhumeshwer KATRE. All rights reserved.
//

import Foundation
// CARD type
public enum Suit: Int, CaseIterable {
    case CLUB = 1
    case DIAMOND
    case HEART
    case SPADE
}

// RANK of the card
public enum Rank: Int, CaseIterable {
    case ACE = 1
    case TWO
    case THREE
    case FOUR
    case FIVE
    case SIX
    case SEVEN
    case EIGHT
    case NINE
    case TEN
    case JACK
    case QUEEN
    case KING //king is 13
}

// Represents a card and its attributes like Rank, suit
class Card {
    private var rank: Rank = .ACE
    private var suit: Suit = .SPADE
    private var faceUp: Bool = false
    fileprivate static let totalCard: Int = 52
    init(withRank rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    static var getTotalCard: Int {
        return Card.totalCard
    }

    var getRank: Rank {
        return rank
    }

    var getSuit: Suit {
        return suit
    }

    var isFaceUp: Bool {
        return faceUp
    }

    func turnOver() {
        faceUp = !faceUp
    }
}

class Deck {
    private var cards = [Card]()
    private var topCard: Int = -1

    init() {
        var i = 0
        cards.reserveCapacity(Card.totalCard)
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                let card = Card(withRank: rank, suit: suit)
                cards.append(card)
                i += 1
            }
        }

        topCard = 0
    }

    var remainingCard: Int {
        return Card.totalCard - topCard
    }

    func shuffle() {
        var items = cards
        cards.removeAll()
        for _ in 0..<items.count {
            let rand = Int(arc4random_uniform(UInt32(items.count)))
            cards.append(items[rand])
            items.remove(at: rand)
        }
    }

    var draw: Card? {
        if topCard < Card.totalCard {
            let result = cards[topCard]
            topCard += 1
            return result
        }

        return nil
    }
}

class Snap {
    private var topCards = [Card]()
    private var deck: Deck!
    private var gameTimer: Timer!
    var score = [Int]()
    var started: Bool = false

    init() {
        deck = Deck()
        topCards.reserveCapacity(2)
        score.reserveCapacity(2)
        score.append(0)
        score.append(0)
    }

    var topCard: Card {
        if topCards.count == 1 {
            return topCards[0]
        }
        return topCards[1]
    }

    var isCardRemain: Bool {
        return deck.remainingCard > 0
    }

    var remainingCard: Int {
        return deck.remainingCard
    }

    func start() {
        if !started {
            deck.shuffle()
            started = true
        }
    }

    func drawGame() {
        if topCards.count > 0 {
            print("Top Card is \(topCards[0].getRank) \(topCards[0].getSuit)")
            print("Player 1 Score \(self.getScoreOfPlayer(0))")
            print("Player 2 Score \(self.getScoreOfPlayer(0))")
        }
    }

    func flipNextCardByPlayer(_ playerIndex: Int) {
        if deck.remainingCard > 0 {
            if let card = deck.draw {
                if topCards.count == 0 {
                    topCards.append(card)
                    topCards[0].turnOver()
                    print("Card Drawn: Player: \(playerIndex)-> \(topCards[0].getSuit): \(topCards[0].getRank)")
                } else if topCards.count == 1 {
                    topCards.append(card)
                    topCards[1].turnOver()
                    print("Card Drawn: Player: \(playerIndex)-> \(topCards[1].getSuit): \(topCards[1].getRank)")
                } else if topCards.count > 1 {
                    topCards[0] = topCards[1]
                    topCards[1] = card
                    topCards[1].turnOver()
                    print("Card Drawn: Player: \(playerIndex)-> \(topCards[1].getSuit): \(topCards[1].getRank)")
                }
            }
        }
    }

    func  update() {

    }

    func getScoreOfPlayer(_ playerIndex: Int) -> Int {
        if playerIndex >= 0 && playerIndex < score.count {
            return score[playerIndex]
        }

        return 0
    }

    func playerHit(_ playerIndex: Int) {
        if playerIndex > -1, playerIndex < score.count, topCards.count > 1, topCards[0].getRank == topCards[1].getRank {
            score[playerIndex] = score[playerIndex] + 1
            started = false
        }
    }
}
