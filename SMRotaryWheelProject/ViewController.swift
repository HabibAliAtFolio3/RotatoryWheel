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
        let containerWidth = self.view.frame.width - 20;
        let wheel = SMRotaryWheel (frame: CGRect(x: 10, y: -(containerWidth/2) + 20, width: containerWidth, height: containerWidth), del: self, sectionsNumber: 10,imageNamesArray: [String](arrayLiteral: "icon0.png","icon1.png","icon2.png","icon3.png","icon4.png"),isSemiCircle:true)
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

