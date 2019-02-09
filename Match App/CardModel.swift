//
//  CardModel.swift
//  Match App
//
//  Created by Игорь Бопп on 08/02/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        // Declare an array to stroe the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        for _ in 1...8 {
            
            let randomNumber = arc4random_uniform(13) + 1
            
            let cardOne = Card()
            let cardTwo = Card()
            
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardOne)
            generatedCardsArray.append(cardTwo)
            
            
        }
        
        // TODO: Randomize the array
        
        // Return the array
        
        return generatedCardsArray
    }
    
}
