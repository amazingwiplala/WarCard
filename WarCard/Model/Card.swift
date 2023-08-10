//
//  Card.swift
//  WarCard
//
//  Created by Jeanine Chuang on 2023/8/9.
//

import Foundation


struct Card: Equatable {
    var Suit: String = ""
    var Rank: String = ""
    var Value: Int = 0

    static func == (A: Card, B: Card) -> Bool {
        return A.Value == B.Value
    }
    static func > (A: Card, B: Card) -> Bool {
        return A.Value > B.Value
    }

}


//花色
enum SUIT {
    case SPADES
    case HEARTS
    case DIAMONDS
    case CLUBS
}


