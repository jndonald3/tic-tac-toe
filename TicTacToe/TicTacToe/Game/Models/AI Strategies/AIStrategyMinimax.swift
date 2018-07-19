//
//  AIStrategyMinimax.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

/**
 * The minimax AI strategy uses minimax to determine which move will given the AI the best chance of winning the game
 * or causing a draw. The minimax strategy will never lose a game, at most it will force a draw
 */
class AIStrategyMinimax: AIStrategy
{
    func execute(forGame game: TicTacToeGame) -> CGPoint?
    {
        // get the open locations on the board
        let openSpots = game.getOpenSpaces()
        
        // ensure there are valid moves left to make
        guard (openSpots.count > 0) else
        { return nil }
        
        // randomly selects a location on the board
        let randomSpot = Int(arc4random_uniform(UInt32(openSpots.count)));
        
        // return the chosen location
        return openSpots[randomSpot]
    }
}
