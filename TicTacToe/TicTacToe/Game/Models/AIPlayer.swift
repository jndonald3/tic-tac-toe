//
//  AIPlayer.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

enum AIMode:Int
{
    case random = 0, Impossible
}

// Represents an AI player within the game
class AIPlayer:Player
{
    //MARK: - Properties -
    private var strategy:AIStrategy
    
    override init(isAttacking: Bool)
    {
        // by default use a random strategy
        self.strategy = AIStrategyRandom(isAttacking: isAttacking)
        
        // properly setup the player
        super.init(isAttacking: isAttacking)
    }
    
    /**
     * Sets the style of AI opponent which the user will be playing against
     */
    public func set(mode:AIMode)
    {
        switch (mode)
        {
            case .random:
                self.useRandomStrategy()
            case .Impossible:
                self.useImpossibleStrategy()
        }
    }
    
    // Sets up this AI player to begin using random moves
    private func useRandomStrategy()
    { self.strategy = AIStrategyRandom(isAttacking: self.isAttacking) }
    
    // Sets up this AI Player to always pick the correct move, it is impossible to beat this AI
    private func useImpossibleStrategy()
    { self.strategy = AIStrategyMinimax(isAttacking: self.isAttacking) }
    
    // Allows the AI player to take its turn
    public func takeTurn(forGame game:TicTacToeGame) -> CGPoint?
    {
        // execute the underlying strategy
        return self.strategy.execute(forGame: game)
    }
}
