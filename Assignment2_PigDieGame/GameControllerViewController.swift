//
//  GameControllerViewController.swift
//  Assignment2_PigDieGame
//
//  Created by Amritbani Sondhi on 2/20/18.
//  Copyright © 2018 Amritbani Sondhi. All rights reserved.
//

import UIKit

class GameControllerViewController: UIViewController
{
    // Round No.
    var gameRound:Int = 0
    var yourTotalPoints:Int = 0
    var compTotalPoints:Int = 0
    var yourFirstTurn:Int = -1
    var isPlaying:Bool = false
    
    var yourDie1Value: Int = 0
    var yourDie2Value: Int = 0
    var compDie1Value: Int = 0
    var compDie2Value: Int = 0
    
    var youDone: Bool = false
    var compDone: Bool = false
    
    @IBOutlet weak var yourDie1: UIImageView!
    @IBOutlet weak var yourDie2: UIImageView!
    @IBOutlet weak var compDie1: UIImageView!
    @IBOutlet weak var compDie2: UIImageView!
    
    @IBOutlet weak var yourTotal: UILabel!
    @IBOutlet weak var compTotal: UILabel!
    
    @IBOutlet weak var yourStatus: UILabel!
    @IBOutlet weak var roundNo: UILabel!
    
    @IBOutlet weak var youPlay: UIButton!
    @IBOutlet weak var compPlay: UIButton!
    
    @IBOutlet weak var rollTheDieOut: UIButton!
    @IBOutlet weak var continueButt: UIButton!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Dark_Theme.png")
        self.view.insertSubview(backgroundImage, at: 0)
        
        roundNo.text = ""
        yourDie1.image = UIImage(named:"d-0")
        yourDie2.image = UIImage(named:"d-0")
        compDie1.image = UIImage(named:"d-0")
        compDie2.image = UIImage(named:"d-0")
        yourTotal.text = String(yourTotalPoints)
        compTotal.text = String(compTotalPoints)
        yourStatus.text = ""
        gameRound += 1
        roundNo.text = String(gameRound)
        result.text = ""
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstYou(_ sender: UIButton)
    {
        yourStatus.text = "Your Chance!"
        compPlay.alpha = 0.0
        youPlay.alpha = 1.0
        yourFirstTurn = 1
        rollTheDieOut.alpha = 1.0
    }
    
    @IBAction func firstComp(_ sender: UIButton)
    {
        yourStatus.text = "Computer's Chance!"
        youPlay.alpha = 0.0
        compPlay.alpha = 1.0
        rollTheDieOut.alpha = 0.5
        yourFirstTurn = 0
        playComputerDie()
    }
    
    @IBAction func rollTheDie(_ sender: UIButton)
    {
        if(isPlaying)
        {
            // Alert if the computer is yet to get over with it's chance
            popAlert(title: "It is Computer's Chance", msg: "Have Patience! The Computer's chance is yet to finish..")
        }
        else if(yourFirstTurn == -1)
        {
            // Alert that please select who'll play first
            popAlert(title: "Invalid Selection", msg: "Please select who plays first..")
        }
        else if(youDone)
        {
            // Alert if you've aready played
            popAlert(title: "Your Turn is over", msg: "You've already Played! Please wait for your next turn..")
        }
        else
        {
            // Your Turn
            self.youDone = true

            yourDie1Value = 1 + Int(arc4random_uniform(6))
            yourDie1.image = UIImage(named: getImage(val: yourDie1Value))
            transEffect()
            //yourTotalPoints += yourDie1Value
            //yourTotal.text = String(yourTotalPoints)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:
            {
                self.yourDie2Value = 1 + Int(arc4random_uniform(6))
                self.yourDie2.image = UIImage(named: self.getImage(val: self.yourDie2Value))
                //self.yourTotalPoints += self.yourDie2Value
                self.yourTotal.text = String(self.yourTotalPoints)
                self.transEffect()
                self.rollTheDieOut.alpha = 0.5
                
                if(self.yourFirstTurn == 1)
                {
                    self.yourStatus.text = "Computer's Chance!"
                    self.playComputerDie()
                }
                self.checkIfEnd()
            })
        }
    }
    
    @IBAction func nextRound(_ sender: Any)
    {
        if(youDone && compDone)
        {
            continueButt.alpha = 0.5
            youPlay.alpha = 1.0
            compPlay.alpha = 1.0
            yourDie1.image = UIImage(named:"d-0")
            yourDie2.image = UIImage(named:"d-0")
            compDie1.image = UIImage(named:"d-0")
            compDie2.image = UIImage(named:"d-0")
            yourTotal.text = String(yourTotalPoints)
            compTotal.text = String(compTotalPoints)
            yourStatus.text = ""
            gameRound += 1
            roundNo.text = String(gameRound)
            result.text = ""
            
            yourFirstTurn = -1
            youDone = false
            compDone = false
        }
        else
        {
            // Invalid Action
            popAlert(title: "Invalid Action", msg: "Complete the current game first!")
        }
    }
    
    @IBAction func resetGame(_ sender: UIButton)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:
            {
        self.gameRound = 0
        self.yourTotalPoints = 0
        self.compTotalPoints = 0
        self.yourFirstTurn = -1
        self.isPlaying = false
        
        self.youDone = false
        self.compDone = false
        
        self.roundNo.text = ""
        self.yourDie1.image = UIImage(named:"d-0")
        self.yourDie2.image = UIImage(named:"d-0")
        self.compDie1.image = UIImage(named:"d-0")
        self.compDie2.image = UIImage(named:"d-0")
        self.yourTotal.text = String(self.yourTotalPoints)
        self.compTotal.text = String(self.compTotalPoints)
        self.yourStatus.text = ""
        self.result.text = ""
        self.gameRound += 1
        self.roundNo.text = String(self.gameRound)
        self.compPlay.alpha = 1.0
        self.youPlay.alpha = 1.0
        })
    }
    
    @IBAction func close(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func playComputerDie()
    {
        isPlaying = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute:
        {
            self.compDie1Value = 1 + Int(arc4random_uniform(6))
            self.compDie1.image = UIImage(named: self.getImage(val: self.compDie1Value))
            self.transEffect()
            //self.compTotalPoints += self.compDie1Value
            //self.compTotal.text = String(self.compTotalPoints)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:
                {
                    self.compDie2Value = 1 + Int(arc4random_uniform(6))
                    self.compDie2.image = UIImage(named: self.getImage(val: self.compDie2Value))
                    //self.compTotalPoints += self.compDie2Value
                    self.compTotal.text = String(self.compTotalPoints)
                    self.transEffect()
                    
                    self.compDone = true
                    self.checkIfEnd()
                    
                    if(self.yourFirstTurn == 0)
                    {
                        // Computer played first
                        self.rollTheDieOut.alpha = 1.0
                        self.yourStatus.text = "Your Chance!"
                    }
                    self.isPlaying = false
            })

        })
    }
    
    func transEffect()
    {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func checkIfEnd()
    {
        if(youDone && compDone)
        {
            let yourPoints = yourDie1Value + yourDie2Value
            let compPoints = compDie1Value + compDie2Value
            
            if(yourPoints > compPoints)
            {
                yourTotalPoints += yourPoints
                yourTotal.text = String(yourTotalPoints)
                result.text = "Yay!! You Won!!"
                yourStatus.text = "Want to play the next Round?"
            }
            else if(yourPoints < compPoints)
            {
                compTotalPoints += compPoints
                compTotal.text = String(compTotalPoints)
                result.text = "Oh Oh! The Computer Won!"
                yourStatus.text = "Want to play the next Round?"
            }
            else
            {
                yourStatus.text = """
                It's a Tie!
                Want to play the next Round?
                """
            }
            continueButt.alpha = 1.0
        }
    }
    
    func popAlert(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in self.yourStatus.text = "Alert Happened!" })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getImage(val: Int)-> String
    {
        var imgName = ""
        
        if(val == 1)
        {
            imgName = "d-1"
        }
        else if(val == 2)
        {
            imgName = "d-2"
        }
        else if(val == 3)
        {
            imgName = "d-3"
        }
        else if(val == 4)
        {
            imgName = "d-4"
        }
        else if(val == 5)
        {
            imgName = "d-5"
        }
        else if(val == 6)
        {
            imgName = "d-6"
        }
        else
        {
            imgName = "d-0"
        }
        return imgName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
