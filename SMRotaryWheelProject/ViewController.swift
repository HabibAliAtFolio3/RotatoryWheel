//
//  ViewController.swift
//  RotaryWheelProject
//
//  Created by Admin on 8/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SMRotaryProtocol {
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let containerWidth : CGFloat = 355 //this is hard coded to fix it with the circular image of width 200, other wise this can be any value
        let wheel = SMRotaryWheel (frame: CGRect(x: (screenWidth - containerWidth)/2, y: -(containerWidth/2), width: containerWidth, height: containerWidth))
        //, del: self, sectionsNumber: 10,imageNamesArray: [String](arrayLiteral: "icon0.png","icon1.png","icon2.png","icon3.png","icon4.png"),isSemiCircle:true
        wheel.delegate = self
        wheel.numberOfSections = 10
        wheel.imageNames = [String](arrayLiteral: "icon0.png","icon1.png","icon2.png","icon3.png","icon4.png")
        wheel.isSemiCircle = true
        wheel.scale = 1.5
        wheel.reloadView()
        view.addSubview(wheel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wheelDidChangeValue (newValue: String) {
        print ("changed value to \(newValue)")
    }
    
}

