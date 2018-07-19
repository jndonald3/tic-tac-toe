//
//  Player.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import Foundation

// Represents any kind of player in the game
class Player
{
    // Whether this player plays with the attacking "X" piece, or the defending "O" piece
    private(set) public var isAttacking:Bool
    
    /**
     * Creates a new player which can be set to attacking or not attacking
     * @param isAttacking: Determins whether this player controls the attacking piece or defending piece, set to true for the player to control attacking pieces
     */
    init(isAttacking:Bool)
    {
        self.isAttacking = isAttacking
    }
}
