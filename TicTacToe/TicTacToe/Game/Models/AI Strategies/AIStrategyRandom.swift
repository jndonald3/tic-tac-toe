//
//  AIStrategyRandom.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

/**
 * The random AI strategy simply asks the board for all of the open locations and then
 * randomly selects one of those locations to place a piece
 */
class AIStrategyRandom:AIStrategy
{
    //MARK: - Properties -
    private var isAttacking:Bool
    
    required init(isAttacking: Bool)
    { self.isAttacking = isAttacking }
    
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
