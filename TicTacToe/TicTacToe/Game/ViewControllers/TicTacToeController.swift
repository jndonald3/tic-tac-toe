//
//  TicTacToeController.swift
//  TicTacToe
//
//  Created by James Donald on 7/18/18.
//  Copyright © 2018 JamesDonald. All rights reserved.
//

import UIKit

protocol TicTacToeControllerDelegate: class
{
    /**
     * This function is called whenever the game has ended and the player has either won, loss, or drawn with the AI player
     */
    func tictactoecontrollerDidEndGame(_ controller:TicTacToeController)
}

/**
 * The tic tac toe controller is responsible for managing the player turns and interactions with the game board in the game
 */
class TicTacToeController: UIViewController
{
    //MARK: - Delegate -
    public var delegate:TicTacToeControllerDelegate?
    
    //MARK: - Gameplay -
    // The game which is currently being played
    private var game:TicTacToeGame = TicTacToeGame()
    // The human player in the game
    private var pc:Player?
    // The AI player in the game
    private var npc:AIPlayer?
    
    //MARK: - UI -
    public static let identifier:String = "TicTacToeController"
    @IBOutlet fileprivate var collectionView:UICollectionView?
    @IBOutlet fileprivate var giveupButton:UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.registerCells()
    }
    
    // If the player gives up, then they lose the game
    @IBAction fileprivate func pressedGiveup(_ sender:Any?)
    { self.displayLossMessage() }
    
    /**
     * This function properly initializes the game and creates 1 human player and 1 AI player
     * @param attackingPlayer: True if the human player is playing as the attacking player, false if the AI player is attacking
     */
    public func setup(withAttackingPlayer pcIsAttacking:Bool)
    {
        // create the players
        self.pc  = Player(isAttacking: pcIsAttacking)
        self.npc = AIPlayer(isAttacking: !pcIsAttacking)
        
        // if the AI is the attacking player, it should take its turn first
        if(!pcIsAttacking)
        { self.takeAITurn() }
        
        // refresh the board
        self.collectionView?.reloadData()
    }
    
    // Registers any colletion view cells with the collection view for display
    private func registerCells()
    {
        // ensure that the collection view is properly initialized
        guard let cv = self.collectionView else
        { return }
        
        TicTacToeCell.register(forCollectionView: cv)
    }
    
    // Converts an index path on the screen to a 2D board point
    fileprivate func calculatePoint(fromIndexPath path:IndexPath) -> CGPoint
    {
        // calculate the board index
        let row = path.row / TicTacToeGame.kMaxSpaces
        let col = path.row % TicTacToeGame.kMaxSpaces
        return CGPoint(x: row, y: col)
    }
    
    // Allows the AI player to attempt to take its turn by making a move on the game board
    fileprivate func takeAITurn()
    {
        // ensure we have an AI player
        guard let npc = self.npc else
        { return }
        
        // Allow the AI player to take its turn if there are still moves available
        if let aiLocation = npc.takeTurn(forGame: self.game)
        {
            let piece = (npc.isAttacking) ? TicTacToePiece.createAttackingPiece() : TicTacToePiece.createDefendingPiece()
            self.game.setPiece(atRow: Int(aiLocation.x), col: Int(aiLocation.y), piece: piece)
            
            // get the cell at the location, and update the ui board
            let itemLocation = (Int(aiLocation.x) * TicTacToeGame.kMaxSpaces) + Int(aiLocation.y)
            let indexPath = IndexPath(item: itemLocation, section: 0)
            if let cell = self.collectionView?.cellForItem(at: indexPath) as? TicTacToeCell
            { cell.setup(withPiece: piece) }
        }
    }
    
    /**
     * This function will check if the game has been won by any player in the game
     */
    fileprivate func checkGameOver() -> Bool
    {
        // ensure that we have valid players
        guard let pc = self.pc, let _ = self.npc else
        {
            // we are missing one of the players, end the game
            self.endGame()
            return true
        }
        
        // check if a player has won the game
        if let winner = self.game.checkWinner()
        {
            // check if the player has won
            if(winner.isAttacker())
            {
                if(pc.isAttacking)
                { self.displayWonMessage() }
                else
                { self.displayLossMessage() }
            }
            else // the defender has won the game
            {
                if(pc.isAttacking)
                { self.displayLossMessage() }
                else
                { self.displayWonMessage() }
            }
            
            return true
        }
        
        // if there is no winner and there are no more moves to make, then the game is a draw
        let openSpots = self.game.getOpenSpaces()
        if(openSpots.count <= 0)
        {
            self.displayDrawMessage()
            return true
        }
        
        return false
    }
    
    // Displays the message for when the computer player has won the game
    private func displayLossMessage()
    {
        let controller = UIAlertController(
            title: NSLocalizedString("You Lose", comment: "You Lose"),
            message: NSLocalizedString("You loss, Maybe next time!", comment: "You loss, Maybe next time!"),
            preferredStyle: .alert)
        
        weak var weakself = self
        controller.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK"),
            style: .default,
            handler: {(action) in weakself?.endGame() })
        )
        
        self.present(controller, animated: true)
    }
    
    // Displays the message for when the human player has won the game
    private func displayWonMessage()
    {
        let controller = UIAlertController(
            title: NSLocalizedString("You Win", comment: "You Win"),
            message: NSLocalizedString("Congragulations! You Won!", comment: "Congragulations! You Won!"),
            preferredStyle: .alert)
        
        weak var weakself = self
        controller.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK"),
            style: .default,
            handler: {(action) in weakself?.endGame() })
        )
        
        self.present(controller, animated: true)
    }
    
    // Displays the message for the final game state when neither the player or the computer has won the game
    private func displayDrawMessage()
    {
        let controller = UIAlertController(
            title: NSLocalizedString("Draw", comment: "Draw"),
            message: NSLocalizedString("Draw Game! Maybe try one more time?", comment: "Draw Game! Maybe try one more time?"),
            preferredStyle: .alert)
        
        weak var weakself = self
        controller.addAction(UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK"),
            style: .default,
            handler: {(action) in weakself?.endGame() })
        )
        
        self.present(controller, animated: true)
    }
    
    // Ends the game by telling the delegate to dismiss the board controller
    private  func endGame()
    { self.delegate?.tictactoecontrollerDidEndGame(self) }
}

//MARK: - TicTacToeCellDelegate -
extension TicTacToeController:TicTacToeCellDelegate
{
    func tictactoeCellDidPlacePiece(_ cell: TicTacToeCell)
    {
        // get the index path for the cell
        guard let indexPath = self.collectionView?.indexPath(for: cell) else
        { return }
        
        // get the player object representing the human player
        guard let pc = self.pc else
        { return }
        
        // convert the index path into a game board index
        let pt = self.calculatePoint(fromIndexPath: indexPath)
        
        // create a piece based on the player
        let piece = (pc.isAttacking) ? TicTacToePiece.createAttackingPiece() : TicTacToePiece.createDefendingPiece()
        
        // set the piece for the player at the given location
        self.game.setPiece(atRow: Int(pt.x), col: Int(pt.y), piece: piece)
        
        cell.setup(withPiece: piece)
        
        // reload the collection view
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
        // check if the game is over
        guard self.checkGameOver() == false else
        { return }
        
        // Allow the AI player to take its turn
        self.takeAITurn()
        
        // reload the collection view
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
        // check if the game is over
        guard self.checkGameOver() == false else
        { return }
    }
}

//MARK: - UICollectionViewDataSource -
extension TicTacToeController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    { return TicTacToeGame.kMaxSpaces * TicTacToeGame.kMaxSpaces }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {        
        // create the cell to be displayed for the user
        var cell = UICollectionViewCell(frame: CGRect())
        
        // setup the cell with the tic tac toe piece
        if let ticTacToeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacToeCell.reuseIdentifier(), for: indexPath) as? TicTacToeCell
        { cell = ticTacToeCell }
        
        // return the cell for display
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        // get the board index
        let pt = self.calculatePoint(fromIndexPath: indexPath)
        
        // grab the piece at that location
        let piece = self.game.getPiece(atRow: Int(pt.x), col: Int(pt.y))
        
        // setup the cell with the tic tac toe piece
        if let ticTacToeCell = cell as? TicTacToeCell
        {
            ticTacToeCell.setup(withPiece: piece)
            ticTacToeCell.delegate = self
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    { return 1 }
}

//MARK: - UICollectionViewDelegateFlowLayout -
extension TicTacToeController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else
        { return CGSize() }
        
        let cvSize = collectionView.frame.size
        let interimSpacing = flow.minimumInteritemSpacing
        let lineSpacing = flow.minimumLineSpacing
        let cellWidth = floor(cvSize.width - (4*interimSpacing))/3
        let cellHeight = floor(cvSize.height - (4*lineSpacing))/3
        return CGSize(width: cellWidth, height: cellHeight);
    }
}
