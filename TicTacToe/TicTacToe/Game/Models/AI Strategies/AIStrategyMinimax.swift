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
    //MARK: - Properties -
    private static let winScore:Int64   = 10
    private static let loseScore:Int64  = -10
    private static let drawScore:Int64  = 0
    private var isAttacking:Bool
    
    required init(isAttacking: Bool)
    { self.isAttacking = isAttacking }
    
    func execute(forGame game: TicTacToeGame) -> CGPoint?
    {
        // run the minimax algorithm
        let (_, bestMove) = self.minimax(gameState: game, isMaximizing: true)
        
        // return the best possible move the AI player can make to maximize its chances of winning
        return bestMove
    }
    
    /**
     * The minimax algorithm: This function attempts to make moves based on the optimal choices left for each player
     * on their corresponding turn after a move has been selected
     * @param gameState: The current game state to evaluate
     * @param isMaximizing: True if the AI should be trying to win during this simulation, false if the AI should be trying to lose
     * @returns The heuristic score for the given board state and the best possible move in this state
     */
    private func minimax(gameState:TicTacToeGame, isMaximizing:Bool) -> (Int64, CGPoint?)
    {
        // get the available moves
        let openMoves = gameState.getOpenSpaces()
        
        // if a player has won, this is a terminal state. There are no next moves in terminal states
        let winner = gameState.checkWinner()
        guard (winner == nil) else
        {
            // the score to return
            var score:Int64 = AIStrategyMinimax.drawScore
            // check if the AI player won
            if(winner?.isAttacker() ?? false)
            { score = (self.isAttacking) ? AIStrategyMinimax.winScore : AIStrategyMinimax.loseScore }
            else
            { score = (self.isAttacking) ? AIStrategyMinimax.loseScore : AIStrategyMinimax.winScore }
            
            return (score, nil)
        }

        // if there are no moves left, this is a terminal state
        guard (openMoves.count > 0) else
        { return (AIStrategyMinimax.drawScore, nil) }

        // get all available moves
        var bestMove:CGPoint?   = nil
        var bestMoveValue       = (isMaximizing) ? Int64.min : Int64.max
        for move in gameState.getOpenSpaces()
        {
            // make this move
            var copyState = gameState
            let pieceToPlace = self.createPieceToPlace(forIsAttacking: self.isAttacking, andIsMaximizing: isMaximizing)
            copyState.setPiece(atRow: Int(move.x), col: Int(move.y), piece: pieceToPlace)
            
            // recurse to simulate the opponent's move
            let (score, _) = self.minimax(gameState: copyState, isMaximizing: !isMaximizing)

            // check the value of this state
            let prevBestValue = bestMoveValue
            bestMoveValue = (isMaximizing) ? max(bestMoveValue, score) : min(bestMoveValue, score)
            
            // if we found a better move, set that as the new best move
            if(prevBestValue != bestMoveValue)
            { bestMove = move }
        }
        
        // return the best possible score and move
        return (bestMoveValue, bestMove)
    }
    
    /**
     * This function creates the correct piece to place for a particular combination of attacking player vs maximizing step in minimax
     * The piece should alternate accordingly so that the AI can simulate the best player choices left after it has made its choice
     * @param isAttacking: True if the AI player is the attacking player in the game
     * @param isMaximizing: True if the current player is the AI player, false if the current player is the human player (in minimax simulation)
     */
    private func createPieceToPlace(forIsAttacking isAttacking:Bool, andIsMaximizing isMaximizing:Bool) -> TicTacToePiece
    {
        if(isAttacking)
        {
            return (isMaximizing) ? TicTacToePiece.createAttackingPiece() : TicTacToePiece.createDefendingPiece()
        }
        else
        {
            return (isMaximizing) ? TicTacToePiece.createDefendingPiece() : TicTacToePiece.createAttackingPiece()
        }
    }
}
