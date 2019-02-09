//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Игорь Бопп on 08/02/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card: Card){
        
        self.card = card
        
        if card.isMatched == true {
            
            // If the card has been matched, then make the image views invisible
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            return
            
        } else {
            
            // If the card hasn't been matched, then make the image views visible
            frontImageView.alpha = 1
            backImageView.alpha = 1
            
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isFlipped{
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove(){
        
        // Remove both imageViews from being visible
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
}
