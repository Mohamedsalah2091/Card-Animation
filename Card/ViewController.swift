//
//  ViewController.swift
//  Card
//
//  Created by MAK on 6/18/20.
//  Copyright © 2020 MAK. All rights reserved.
//

import UIKit

struct filmData {
    var image : UIImage!
    var name : String!
    var discription : String!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var imageNavigation: UIImageView!
    var divisor : CGFloat!
    
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmDescription: UITextView!
    
    var data = [filmData]()
    var temp : filmData!
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = view.frame.width / 2
        imageNavigation.alpha = 0
        declaration()
        
        
        
    }
    func declaration(){
        temp = filmData(image: #imageLiteral(resourceName: "m1.jpg"), name: "Avatar", discription: """
        Soon after hitting theaters in 2009, Avatar became one of the highest grossing movies of all time. Using the newly invented (at that time) motion capture technique, 3-D viewing and the use of stereoscopic filmmaking, it’s no surprise that the film won
        """  )
        data.append(temp)
        
        temp = filmData(image: #imageLiteral(resourceName: "m2"), name: "Frozen", discription: """
        I don’t know about you, but hearing Olaf described as a carrot nosed snowman shuffling up to a purple flower is enough of a reason for me to watch Frozen with audio description. Thanks to Pixar’s Disney Movies Anywhere App, which allows users to watch most Pixar films with audio description, you can watch this all-time favorite with incredible descriptions. It really doesn’t get much cuter!
        """  )
        data.append(temp)
        
        temp = filmData(image: #imageLiteral(resourceName: "m3"), name: "Finding Nemo", discription: """
        This one is right up there with Frozen. (You’re likely starting to get a good sense of my movie taste.) Listening to Finding Nemo with audio description can take you on a wonderful deep sea dive through the Great Barrier Reef that you’ll enjoy even if you don’t like to swim. This Academy Award-winning animated film takes us on a journey below the sea. Without audio description, you’ll miss out on the vibrant aquatic life and sea creatures met along the way.
        """  )
        data.append(temp)
    }
    
    
    @IBAction func dragCard(_ sender: UIPanGestureRecognizer) {
        var card = sender.view!
        let point = sender.translation(in: view)
        let xCenter = card.center.x - view.center.x
        moveCard(card: &card, cardPoint: point , mainViewPoint: view.center)
        navigateImage(cardPoint: card.center , mainViewPoint: view.center, imageNavigation: &imageNavigation)
        
        let scale = min(100/abs(xCenter) , 1)
        card.transform = CGAffineTransform(rotationAngle: xCenter / divisor).scaledBy(x: scale, y: scale)
        
        if sender.state == UIGestureRecognizer.State.ended{
            if !(moveToCorner(cardX: card.center.x, cardY: card.center.y)){
                originalPosition()
            }
        }
        
    }
    
    func originalPosition(){
        UIView.animate(withDuration: 0.4) {
            self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            self.imageNavigation.alpha = 0
            self.card.transform = .identity
            self.card.alpha = 1
        }
    }
    func moveToCorner(cardX: CGFloat , cardY: CGFloat  ) ->Bool{

        if card.center.x < 75 && index + 1 < data.count{ // left
            UIView.animate(withDuration: 0.3, animations: {
                self.card.center = CGPoint(x: cardX - 200, y: cardY + 75)
                self.card.alpha = 0
                self.imageNavigation.alpha = 0
                self.index += 1
                self.cardIndex(cIndex: self.index)
                
            }) { _ in
                self.card.center = CGPoint(x: cardX + 400, y: cardY + 75)
                self.originalPosition()
            }
            return true
        }else if card.center.x > (view.frame.width - 75) && index > 0{ // right

            UIView.animate(withDuration: 0.3, animations: {
                self.card.center = CGPoint(x:cardX + 200, y: cardY + 75)
                self.card.alpha = 0
                self.imageNavigation.alpha = 0
                self.index -= 1
                self.cardIndex(cIndex: self.index)
                
            }) { _ in
                self.card.center = CGPoint(x:cardX - 400, y: cardY + 75)
                self.originalPosition()
            }
            return true
        }
        return false
    }
    func cardIndex( cIndex : Int){
        filmImage.image = data[cIndex].image
        filmName.text = data[cIndex].name
        filmDescription.text = data[cIndex].discription
    }
    
    
    func moveCard(card : inout UIView , cardPoint : CGPoint , mainViewPoint : CGPoint){
        card.center = CGPoint(x: cardPoint.x + mainViewPoint.x, y: cardPoint.y + mainViewPoint.y)
    }
    func navigateImage(cardPoint : CGPoint , mainViewPoint : CGPoint, imageNavigation : inout UIImageView){
        let xCenter = cardPoint.x - mainViewPoint.x
        if xCenter > 0 {
            imageNavigation.image = #imageLiteral(resourceName: "Back")
        }else{
            imageNavigation.image = #imageLiteral(resourceName: "next")
        }
        imageNavigation.alpha = abs(xCenter) / mainViewPoint.x
    }
    
    
    
    
    
}

