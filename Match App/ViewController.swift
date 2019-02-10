//
//  ViewController.swift
//  Match App
//
//  Created by Игорь Бопп on 08/02/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var model = CardModel()
    var cardArray = [Card]()
    var timer: Timer?
    var milliseconds: Float = 20 * 1000 // 20 seconds
    var firstFlippedCardIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
        
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        timerLabel.text? = "Time remaining: \(seconds)"
        
        if milliseconds <= 0 {
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            checkGameEnded()
        }
        
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.setCard(cardArray[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            
            cell.flip()
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
                
            }else{
                checkForMatches(indexPath)
            }
        }
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath){
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cells for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there any cards left unmatched
            checkGameEnded()
            
        } else {
            
            // It's not a match
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        // Tell the collectionview to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
            
        }
        
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded(){
        
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false {
                isWon = false
                break
            }
            
        }
        
        // Messaging
        var title = ""
        var message = ""
        
        if isWon {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won!"
            
        } else {
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost :("
            
        }
        
        showAlert(title, message)
        
    }
    
    func showAlert(_ title: String, _ message: String){
        
        // Show won/lost messaging
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActon = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertActon)
        present(alert, animated: true, completion: nil)
        
    }
}

