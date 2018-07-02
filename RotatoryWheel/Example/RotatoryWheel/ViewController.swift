//
//  ViewController.swift
//  RotaryWheelProject
//
//  Created by Habib Ali on 8/28/17.
//  Copyright © 2017 Habib Ali. All rights reserved.
//

import UIKit
import RotatoryWheel

class ViewController: UIViewController, F3RotatoryWheelProtocol {
    
    @IBOutlet weak var wheel: F3RotatoryWheel!
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is alternate way to init wheel
        //let screenWidth = UIScreen.main.bounds.width
        //let containerWidth : CGFloat = screenWidth - 20 // can be any value
        //let wheel = SMRotaryWheel (frame: CGRect(x: (screenWidth - containerWidth)/2, y: -(containerWidth/2), width: containerWidth, height: containerWidth))
        //view.addSubview(wheel)
        
        
        //Another way to init wheel is to add it in nib or storyboard
        //Make sure you make the width and height equal
        //To make it semicircular hide the other half from the screen by adjusting its constraints
        
        
        //Wheel initialization
        wheel.delegate = self
        wheel.numberOfSections = 10
        wheel.imageNames = [String](arrayLiteral: "icon0.png","icon1.png","icon2.png","icon3.png","icon4.png")
        wheel.isSemiCircle = true
        wheel.scale = 1.5
        wheel.itemSize = CGSize(width: 70, height: 70) //Image size
        wheel.rotateWheelByOffset = 0.1 //due to image size some time you have to tweak this offset when semi circle mode is selected
        wheel.reloadView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wheelDidChangeValue (newValue: String) {
        print ("changed value to \(newValue)")
    }
    
}

