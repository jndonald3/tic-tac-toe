//
//  MasterViewController.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

/**
 * The MasterViewController is responsible for setting the game settings and Presenting and dismissing the game
 */
class MasterViewController: UIViewController
{
    //MARK: - UI -
    @IBOutlet fileprivate var attackButton:UIButton?
    @IBOutlet fileprivate var defendButton:UIButton?
    @IBOutlet fileprivate var difficultySegment:UISegmentedControl?
    @IBOutlet fileprivate var difficultyLabel:UILabel?
    
    //MARK: - Properties
    private static let randomString = NSLocalizedString(
        "Your opponent is unpredictable. The AI seems to randomly pick locations on the board, making it impossible to determine its next move.",
        comment: "Random AI Opponent")
    private static let impossibleString = NSLocalizedString(
        "Your opponent is a genius, making every correct move in every situation. There is no winning against this opponent.",
        comment: "Impossible AI Opponent")
    private var aiMode = AIMode.random
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.attackButton?.layer.borderWidth = 2.0
        self.attackButton?.layer.borderColor = UIColor.black.cgColor
        self.defendButton?.layer.borderWidth = 2.0
        self.defendButton?.layer.borderColor = UIColor.black.cgColor
        
        self.difficultySegment?.selectedSegmentIndex = self.aiMode.rawValue
        self.difficultyChanged(self.difficultySegment)
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
        { tictactoeVC.setup(withAttackingPlayer: playerIsAttacking, andAIMode: self.aiMode) }
    }
    
    // The player wishes to play as the attacking piece
    @IBAction fileprivate func pressedAttack(_ sender:Any?)
    { self.displayGameBoard(playerIsAttacking: true) }
    
    // The player wishes to play as the defending piece
    @IBAction fileprivate func pressedDefend(_ sender:Any?)
    { self.displayGameBoard(playerIsAttacking: false) }
    
    // The player has changed the AI difficulty in the game
    @IBAction fileprivate func difficultyChanged(_ sender:Any?)
    {
        guard let segment = self.difficultySegment,
            let aiMode = AIMode(rawValue: segment.selectedSegmentIndex) else
        { return }
        
        // save the selected mode
        self.aiMode = aiMode
        
        switch(aiMode)
        {
        case .random:
            self.difficultyLabel?.text = MasterViewController.randomString
        case .Impossible:
            self.difficultyLabel?.text = MasterViewController.impossibleString
        }
    }
}

//MARK: - TicTacToeControllerDelegate -
extension MasterViewController: TicTacToeControllerDelegate
{
    func tictactoecontrollerDidEndGame(_ controller: TicTacToeController)
    { self.dismiss(animated: true, completion: nil) }
}
