//
//  ViewController.swift
//  Match App
//
//  Created by Игорь Бопп on 08/02/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model = CardModel()
    var cardArray = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
    }


}

