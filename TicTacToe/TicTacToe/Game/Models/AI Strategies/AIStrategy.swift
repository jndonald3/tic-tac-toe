//
//  AIStrategy.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

/**
 * The interface which must be implemented by a strategy in order for the AI to be able to act on a turn
 */
protocol AIStrategy
{
    /**
     * The required initializer for AIStrategies
     * @param isAttacking: True if the AI player is the attacking player in the game, false if the AI player is the defending player in the game
     */
    init(isAttacking:Bool)
    
    /**
     * Executes the strategy and returns the location which the AI player wishes to make its move
     * @param game: The current tic tac toe game
     * @returns: The location where the AI Player would like to make its move, nil if the computer can not make a valid move
     */
    func execute(forGame game:TicTacToeGame) -> CGPoint?
}
