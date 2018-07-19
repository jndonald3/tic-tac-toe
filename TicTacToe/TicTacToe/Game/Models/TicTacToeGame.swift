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
        
        // check the diagonols in the board
        if let diagWinner = self.checkDiagonols()
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
            // if the first location is nil, skip this iteration
            guard(self.board[row][0] != nil) else
            { continue }
            
            // if each value is the same, then there is a winner
            if(self.board[row][0] == self.board[row][1] && self.board[row][1] == self.board[row][2])
            {
                return self.board[row][0]
            }
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
            // if the first location is nil, skip this iteration
            guard(self.board[0][col] != nil) else
            { continue }
            
            // if each value is the same, then there is a winner
            if(self.board[0][col] == self.board[1][col] && self.board[1][col] == self.board[2][col])
            {
                return self.board[0][col]
            }
        }
        
        return nil
    }
    
    /**
     * Checks each diagonol of the game board to determine if a player has won the game
     * @returns The player who won the game, or nil if no player has won by diagonols
     */
    private func checkDiagonols() -> TicTacToePiece?
    {
        // The middle piece in the board must be set in order for diagonols to be scored
        guard(self.board[1][1] != nil) else
        { return nil }
        
        // There are only 2 possible diagonols, just check with brute force
        if(self.board[0][0] == self.board[1][1] && self.board[1][1] == self.board[2][2])
        {
            return self.board[1][1]
        }
        
        if(self.board[0][2] == self.board[1][1] && self.board[1][1] == self.board[2][0])
        {
            return self.board[1][1]
        }
        
        return nil
    }
}
