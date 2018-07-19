//
//  TicTacToePiece.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import Foundation

// Represents the type of pieces used within the game
// X is the attacking player's piece
// O is the defending player's piece
enum TicTacToePiece: String
{
    case x      = "X"
    case o      = "O"
    
    // returns true if the this piece represents the attacking player
    public func isAttacker() -> Bool
    { return self == .x }
    
    /**
     * Creates a tic tac toe piece which represents the attacking character
     */
    static func createAttackingPiece() -> TicTacToePiece
    { return TicTacToePiece.x }
    
    /**
     * Creates a tic tac toe piece which represents the defending character
     */
    static func createDefendingPiece() -> TicTacToePiece
    { return TicTacToePiece.o }
}
