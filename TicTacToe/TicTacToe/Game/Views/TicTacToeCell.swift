//
//  TicTacToeCell.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

protocol TicTacToeCellDelegate: class
{
    func tictactoeCellDidPlacePiece(_ cell:TicTacToeCell)
}

class TicTacToeCell: UICollectionViewCell
{
    // The delegate which handles player interaction with the cell
    internal var delegate:TicTacToeCellDelegate?
    
    // The button associated with this cell
    // If the cell is disabled, the button should show the selected piece which was placed at that board location
    @IBOutlet fileprivate  var button:UIButton?
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.button?.isHidden = true
        self.button?.setTitle(nil, for: UIControlState.normal)
        self.button?.layer.borderWidth = 2.0
        self.button?.layer.borderColor = UIColor.black.cgColor
    }
    
    /**
     * Properly configures the cell for display
     * @param piece: The piece which should be dislayed by this board cell
     * @note: a nil piece indicates that a player has not yet played on this cell, and the cell should be enabled
     */
    func setup(withPience piece:TicTacToePiece?)
    {        
        if let placedPiece = piece
        {
            // A Player has played on this location, setup the cell to display the player's piece
            self.button?.setTitle(placedPiece.rawValue, for: UIControlState.normal)
            self.isUserInteractionEnabled = false
            self.button?.isUserInteractionEnabled = false
        }
        else
        {
            self.button?.setTitle("", for: UIControlState.normal)
            self.isUserInteractionEnabled = true
            self.button?.isUserInteractionEnabled = true
        }
        
        self.button?.isHidden = false
    }
    
    /**
     * Properly registers this cell with the given collection view for display
     * @param collectionView: The collection view which will be used to display this cell
     */
    internal class func register(forCollectionView collectionView:UICollectionView)
    {
        let nib = UINib(nibName: self.reuseIdentifier(), bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier())
    }
    
    /// @returns: the reuse identifier which should be used for the cell
    internal class func reuseIdentifier() -> String
    { return String(describing: self) }
    
    // called whenever a player places a piece at this cell location
    @IBAction func placedPiece(_ sender:Any?)
    { self.delegate?.tictactoeCellDidPlacePiece(self) }
}
