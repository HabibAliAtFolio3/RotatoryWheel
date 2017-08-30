//
//  SMRotaryWheel.swift
//  RotaryWheelProject
//
//  Created by Admin on 8/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import QuartzCore

protocol SMRotaryProtocol {
    func wheelDidChangeValue (newValue: String)
}

class SMRotaryWheel: UIControl {
    
    var delegate: SMRotaryProtocol?
    var container: UIView?
    var numberOfSections: Int = 0
    
    static var deltaAngle: Float = 0
    var startTransform: CGAffineTransform = CGAffineTransform( rotationAngle: CGFloat(0) )
    
    var angleSize: Double {
        get{
            return Double.pi * 2 / Double ( numberOfSections )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init (frame: CGRect, del: SMRotaryProtocol, sectionsNumber: Int) {
        self.init (frame: frame)
        self.numberOfSections = sectionsNumber
        self.delegate = del
        drawWheel ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static  var minAlphavalue: CGFloat = 0.6
    static  var maxAlphavalue: CGFloat = 1.0
    
    func drawWheel() {
        // 1
        container = UIView (frame: frame)
        // 2 this is a class property now, not just a variable in the method
        //let angleSize = CGFloat (2 * Double.pi ) / CGFloat ( numberOfSections );
        // 3
        for i in 0..<numberOfSections {
            
            // 4 - Create image view
            let im = UIImageView (image: UIImage (named: "segment.png") )
            im.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            im.layer.position = CGPoint(x: container!.bounds.size.width/2.0 - container!.frame.origin.x,
                                        y: container!.bounds.size.height/2.0 - container!.frame.origin.y)
            im.transform = CGAffineTransform(rotationAngle: CGFloat ( angleSize ) * CGFloat (i)  );
            im.alpha = SMRotaryWheel.minAlphavalue;
            im.tag = i;
            if (i == 0) {
                im.alpha = SMRotaryWheel.maxAlphavalue;
            }
            // 5 - Set sector image
            let sectorImage = UIImageView ( frame: CGRect(x: 12, y: 15, width: 40, height: 40))
            sectorImage.image = UIImage (named: "icon\(i).png")
            im.addSubview (sectorImage)
            // 6 - Add image view to container
            container!.addSubview (im)
        }
        
        // 7
        container!.isUserInteractionEnabled = false;
        
        // 7.1 - Add background image
        
        let bg = UIImageView (frame: frame)
        bg.image = UIImage (named: "bg.png")
        addSubview (bg)
        
        addSubview (container!)
        
        let mask = UIImageView ( frame: CGRect(x: 0, y: 0, width: 58, height: 58) )
        mask.image = UIImage (named: "centerButton.png")
        //mask.sizeToFit()
        
        mask.center = center
        mask.center = CGPoint (x: mask.center.x, y: mask.center.y+3)
        addSubview (mask)
    }
    
    var currentSector: Int = 0
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1 - Get touch position
        let touchPoint = touch.location(in: self)
        // 1.1 - Get the distance from the center
        let dist = self.calculateDistanceFromCenter (point: touchPoint);
        // 1.2 - Filter out touches too close to the center
        if (dist < 40 || dist > 100)
        {
            // forcing a tap to be on the ferrule
            print( "ignoring tap \(touchPoint.x), \(touchPoint.y)" );
            return false;
        }
        // 2 - Calculate distance from center
        let dx = touchPoint.x - container!.center.x;
        let dy = touchPoint.y - container!.center.y;
        // 3 - Calculate arctangent value
        SMRotaryWheel.deltaAngle = Float( atan2(dy,dx) );
        // 4 - Save current transform
        startTransform = container!.transform;
        
        // 5 - Set current sector's alpha value to the minimum value
        let im = getSectorByValue (currentSector)
        im?.alpha = SMRotaryWheel.minAlphavalue;
        return true;
    }
    
    func getSectorByValue (_ value: Int) -> UIImageView? {
        var res: UIImageView?
        let views = container!.subviews as? [UIImageView]
        for im in views! {
            if im.tag == value {
                res = im; }
        }
        return res;
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let radians = atan2f(Float (  container!.transform.b  ), Float (  container!.transform.a)  )
        print("rad is \(radians)")
        
        let pt = touch.location(in: self)
        let dx = pt.x  - container!.center.x
        let dy = pt.y  - container!.center.y
        let ang = Float ( atan2(dy,dx) )
        let angleDifference = SMRotaryWheel.deltaAngle - ang
        container!.transform = startTransform.rotated( by: CGFloat ( -angleDifference)  )
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        // 1 - Get current container rotation in radians
        let radians = atan2f(Float (  container!.transform.b  ), Float (  container!.transform.a)  )
        // 2 Determine which sector is now selected
        currentSector = calculateNewSector (radians)
        let centerSelected = angleSize / 2 + Double ( currentSector ) * angleSize
        print ("currents degrees = \(radians * 57.3)")
        print ("currents segCenter degrees = \(centerSelected * 57.3)")
        
        let sign: Float = radians < 0 ? -1 : 1
        var rad2 = abs ( radians )
        while rad2 > Float ( angleSize ) {
            rad2 = rad2 - Float ( angleSize )
        }
        
        if rad2 > Float ( angleSize / 2 ) {
            rad2 = rad2 - Float ( angleSize  )
        }
        
        // 3 - Initialize new value
        let newVal = rad2 * sign //centerSelected - Double ( radians ) // Double.pi/4.0;
        
        
        // 4 Rotate to the center of the selected sector
        
        // 7 - Set up animation for final rotation
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        let t = container!.transform.rotated(by: CGFloat(-newVal))
        container!.transform = t
        UIView.commitAnimations()
        
        // 10 - Highlight selected sector
        if let im = getSectorByValue (currentSector) {
            im.alpha = SMRotaryWheel.maxAlphavalue;
        }
        
        // 11 - Report to the caller
        delegate?.wheelDidChangeValue(newValue: String (currentSector))
    }
    
    func calculateNewSector (_ radians:Float) -> Int {
        let x =   Float ( angleSize / 2 + 2 * Double.pi ) - radians
        return Int (x / Float ( angleSize )  ) % numberOfSections
    }
    
    func calculateDistanceFromCenter (point: CGPoint) ->  Float     {
        let center = CGPoint (x: bounds.size.width/2, y: bounds.size.height/2)
        let dx = point.x - center.x;
        let dy = point.y - center.y;
        return Float ( sqrt(dx*dx + dy*dy) );
    }

    
}

