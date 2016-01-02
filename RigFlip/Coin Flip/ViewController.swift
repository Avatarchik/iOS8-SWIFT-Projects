//
//  ViewController.swift
//  Coin Flip
//
//  Created by Matt on 1/14/15.
//  Copyright (c) 2015 Raporte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var frameCount = 0
    
    
    @IBOutlet var coinFlipAnimation: UIImageView!
    
    @IBAction func flip(sender: AnyObject) { //activated with Flip button
        
        frameCount = 0
        
        var timer = NSTimer.scheduledTimerWithTimeInterval((1/5), target: self, selector: Selector("imageUpdate"), userInfo: nil, repeats: true)
        
    }
    
    func imageUpdate(){ //run every second after button is pressed
        
        if frameCount == 41{
            let nextFrame = UIImage(named: ("background.png"))
            coinFlipAnimation.image = nextFrame
            //display results here:
        }
        else {
            let nextFrame = UIImage(named: ("coinflip" + String(frameCount) + ".png"))
            coinFlipAnimation.image = nextFrame
            
            frameCount++
        }
        
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

