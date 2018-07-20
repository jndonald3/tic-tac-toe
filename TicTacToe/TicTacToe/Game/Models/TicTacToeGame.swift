//
//  TicTacToeGame.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

/**
 * Responsible for managing the state of the game
 * Use a struct so that the game can be easily copied
 */
struct TicTacToeGame
{
    //MARK: - Properties -
    // The number of spaces in the game board
    public static let kMaxSpaces = 3
    // the board of tic tac toe pieces
    private var board:[[TicTacToePiece?]]
    
    /**
     * Initialize the game
     */
    init()
    {
        // initialize the board appropriately
        self.board = Array()
        for _ in 0..<TicTacToeGame.kMaxSpaces
        {
            let row = Array<TicTacToePiece?>(repeating: nil, count: TicTacToeGame.kMaxSpaces)
            self.board.append(row)
        }
    }
    
    /**
     * Checks if a player has won the game
     * @returns The player who won the game, or nil if no player has won the game
     */
    public func checkWinner() -> TicTacToePiece?
    {
        // check the rows in the board
        if let rowWinner = self.checkRows()
        {
            return rowWinner
        }
        
        // check the columns in the board
        if let colWinner = self.checkColumns()
        {
            return colWinner
        }

        // check the diagonals in the board
        if let diagWinner = self.checkDiagonals()
        {
            return diagWinner
        }
        
        // no one has won the game
        return nil
    }
    
    /**
     * This function will return the piece located at the given row and column of the tic tac toe board
     * @param row The row of the piece to locate
     * @param col The column of the piece to locate
     * @returns The piece if one has been placed, otherwise nil
     */
    public func getPiece(atRow row:Int, col:Int) -> TicTacToePiece?
    {
        // ensure that the location is within bounds of the board
        guard (row >= 0 && row < TicTacToeGame.kMaxSpaces && col >= 0 && col < TicTacToeGame.kMaxSpaces) else
        {
            assertionFailure("Index out of bounds when asking for piece")
            return nil
        }
        
        // return the piece
        return self.board[row][col]
    }
    
    /**
     * This function will set the piece at the given row and column of the tic tac toe board
     * @param row The row of the piece to locate
     * @param col The column of the piece to locate
     * @param piece The piece to place at the given location if the location is currently empty
     */
    public mutating func setPiece(atRow row:Int, col:Int, piece:TicTacToePiece)
    {
        // ensure that the location is within bounds of the board
        guard (row >= 0 && row < TicTacToeGame.kMaxSpaces && col >= 0 && col < TicTacToeGame.kMaxSpaces) else
        {
            assertionFailure("Index out of bounds when setting a piece")
            return
        }
        
        // ensure that the location doesn't already contain a piece
        guard(self.board[row][col] == nil) else
        {
            assertionFailure("Attempt to overwrite previously placed piece")
            return
        }
        
        // set the piece at the empty location
        self.board[row][col] = piece
    }
    
    /**
     * This function will detect all of the open locations on the game board
     * @returns: All of the open locations where a piece can be potentially placed by a player
     * @note: The x coord of each point represents row and the y coord represents column
     */
    public func getOpenSpaces() -> Array<CGPoint>
    {
        var openLocations = Array<CGPoint>()
        
        for row in 0..<TicTacToeGame.kMaxSpaces
        {
            for col in 0..<TicTacToeGame.kMaxSpaces
            {
                if(self.board[row][col] == nil)
                {
                    let pt = CGPoint(x: row, y: col)
                    openLocations += [pt]
                }
            }
        }
        
        return openLocations
    }
    
    /**
     * Checks each row of the game board to determine if a player has won the game
     * @returns The player who won the game, or nil if no player has won by rows
     */
    private func checkRows() -> TicTacToePiece?
    {
        // check each row in the game board to determine if there is a winner
        for row in 0..<TicTacToeGame.kMaxSpaces
        {
            var won = true
            var currentPlayer:TicTacToePiece? = nil
            for col in 0..<TicTacToeGame.kMaxSpaces
            {
                // check if this location is empty
                guard (self.board[row][col] != nil) else
                {
                    won = false
                    break
                }
                
                // check if the player piece was ever set
                if(currentPlayer == nil)
                {
                    currentPlayer = self.board[row][col]
                }
                else if(currentPlayer != self.board[row][col])
                {
                    // This row has a piece which was not the same as the original piece placed in the row
                    won = false
                    break
                }
            }
            
            // check if this was a 3 in a row case
            if(won && currentPlayer != nil)
            { return currentPlayer }
        }
        
        return nil
    }
    
    /**
     * Checks each column of the game board to determine if a player has won the game
     * @returns The player who won the game, or nil if no player has won by columns
     */
    private func checkColumns() -> TicTacToePiece?
    {
        // check each column in the game board to determine if there is a winner
        for col in 0..<TicTacToeGame.kMaxSpaces
        {
            var won = true
            var currentPlayer:TicTacToePiece? = nil
            for row in 0..<TicTacToeGame.kMaxSpaces
            {
                // check if this location is empty
                guard (self.board[row][col] != nil) else
                {
                    won = false
                    break
                }
                
                // check if the player was ever set
                if(currentPlayer == nil)
                {
                    currentPlayer = self.board[row][col]
                }
                else if(currentPlayer != self.board[row][col])
                {
                    // This column has a piece which was not the same as the original piece placed in the column
                    won = false
                    break
                }
            }
            
            // check if this was a 3 in a column case
            if(won && currentPlayer != nil)
            { return currentPlayer }
        }
        
        return nil
    }
    
    /**
     * Checks each diagonal of the game board to determine if a player has won the game
     * @returns The player who won the game, or nil if no player has won by diagonals
     */
    private func checkDiagonals() -> TicTacToePiece?
    {
        // check the diagonols in the game
        // There are exactly 2 diagonols in tic tac toe: [(0,0), (1,1), (2,2)] && [(0,2), (1,1), (2,0)]
        // The first can be seen to be the pairing of the same index for row and column
        // In the second diagonol, it can be seen that the row is calculated as index, and the column is kMaxSpaces-index-1
        
        // Loop to check the first diagonol (pair of the same index)
        var won = true
        var currentPlayer:TicTacToePiece? = nil
        for diag in 0..<TicTacToeGame.kMaxSpaces
        {
            // check if this location is empty
            guard (self.board[diag][diag] != nil) else
            {
                won = false
                break
            }
            
            // check if the player was ever set
            if(currentPlayer == nil)
            {
                currentPlayer = self.board[diag][diag]
            }
            else if(currentPlayer != self.board[diag][diag])
            {
                // This diagonal has a piece which was not the same as the original piece placed in the diagonal
                won = false
                break
            }
        }
        
        // check if this was a 3 in a row case
        if(won && currentPlayer != nil)
        { return currentPlayer }
        
        // Loop to check the second diagonol (index, kMaxSpaces-index-1)
        won = true
        currentPlayer = nil
        for diag in 0..<TicTacToeGame.kMaxSpaces
        {
            let columnIndex = TicTacToeGame.kMaxSpaces - diag - 1
            // check if this location is empty
            guard (self.board[diag][columnIndex] != nil) else
            {
                won = false
                break
            }
            
            // check if the player was ever set
            if(currentPlayer == nil)
            {
                currentPlayer = self.board[diag][columnIndex]
            }
            else if(currentPlayer != self.board[diag][columnIndex])
            {
                // This diagonal has a piece which was not the same as the original piece placed in the diagonal
                won = false
                break
            }
        }
        
        // check if this was a 3 in a row case
        if(won && currentPlayer != nil)
        { return currentPlayer }
        
        return nil
    }
}
