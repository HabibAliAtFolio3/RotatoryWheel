//
//  ViewController.swift
//  RotaryWheelProject
//
//  Created by Admin on 8/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SMRotaryProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wheel = SMRotaryWheel (frame: CGRect(x: 0, y: 0, width: 200, height: 200), del: self, sectionsNumber: 8)
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

