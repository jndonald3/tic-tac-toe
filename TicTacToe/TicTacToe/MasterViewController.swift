//
//  MasterViewController.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController
{
    //MARK: - UI -
    @IBOutlet fileprivate var attackButton:UIButton?
    @IBOutlet fileprivate var defendButton:UIButton?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.attackButton?.layer.borderWidth = 2.0
        self.attackButton?.layer.borderColor = UIColor.black.cgColor
        self.defendButton?.layer.borderWidth = 2.0
        self.defendButton?.layer.borderColor = UIColor.black.cgColor
    }

    /**
     * Called whenever we should display the tic tac toe game board to play
     * @param playerIsAttacking: True if the player decided to play as the attacking piece, false otherwise
     */
    private func displayGameBoard(playerIsAttacking:Bool)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tictactoeVC = storyboard.instantiateViewController(withIdentifier: TicTacToeController.identifier) as? TicTacToeController else
        { return }
        
        // setup the tic tac toe board
        tictactoeVC.delegate = self
        self.present(tictactoeVC, animated: true)
        { tictactoeVC.setup(withAttackingPlayer: playerIsAttacking) }
    }
    
    // The player wishes to play as the attacking piece
    @IBAction fileprivate func pressedAttack(_ sender:Any?)
    { self.displayGameBoard(playerIsAttacking: true) }
    
    // The player wishes to play as the defending piece
    @IBAction fileprivate func pressedDefend(_ sender:Any?)
    { self.displayGameBoard(playerIsAttacking: false) }
}

//MARK: - TicTacToeControllerDelegate -
extension MasterViewController: TicTacToeControllerDelegate
{
    func tictactoecontrollerDidEndGame(_ controller: TicTacToeController)
    { self.dismiss(animated: true, completion: nil) }
}
