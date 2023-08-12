//
//  Card.swift
//  WarCard
//
//  Created by Jeanine Chuang on 2023/8/9.
//

import Foundation


struct Card: Comparable {
    
    var Suit: String = ""
    var Rank: String = ""
    var Value: Int = 0

    static func < (A: Card, B: Card) -> Bool {
        A.Value < B.Value
    }
    static func == (A: Card, B: Card) -> Bool {
        return A.Value == B.Value
    }
    static func > (A: Card, B: Card) -> Bool {
        return A.Value > B.Value
    }

}


//花色
enum SUIT:String {
    case SPADES = "SPADES"
    case HEARTS = "HEARTS"
    case DIAMONDS = "DIAMONDS"
    case CLUBS = "CLUBS"
}


