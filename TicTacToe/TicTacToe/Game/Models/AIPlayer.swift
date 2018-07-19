//
//  AIPlayer.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

// Represents an AI player within the game
class AIPlayer:Player
{
    //MARK: - Properties -
    private var strategy:AIStrategy
    
    override init(isAttacking: Bool)
    {
        // by default use a random strategy
        self.strategy = AIStrategyRandom()
        
        // properly setup the player
        super.init(isAttacking: isAttacking)
    }
    
    // Sets up this AI player to begin using random moves
    public func useRandomStrategy()
    { self.strategy = AIStrategyRandom() }
    
    // Sets up this AI Player to always pick the correct move, it is impossible to beat this AI
    public func useImpossibleStrategy()
    { self.strategy = AIStrategyMinimax() }
    
    // Allows the AI player to take its turn
    public func takeTurn(forGame game:TicTacToeGame) -> CGPoint?
    {
        // execute the underlying strategy
        return self.strategy.execute(forGame: game)
    }
}
