//
//  F3RotatoryWheel.swift
//  RotaryWheelProject
//
//  Created by Habib Ali on 8/28/17.
//  Copyright © 2017 Habib Ali. All rights reserved.
//

import UIKit
import QuartzCore

public protocol F3RotatoryWheelProtocol {
    func wheelDidChangeValue (newValue: String)
}

class CustomImageView: UIImageView {
    var curYTranslation : CGFloat = 0
    
    public func applyYTranslation(value:CGFloat){
        self.transform = self.transform.translatedBy(x: 0, y: value)
        curYTranslation = value
    }
    
    public func revertYTranslation(){
        if curYTranslation != 0{
            applyYTranslation(value: -curYTranslation)
        }
        curYTranslation = 0
    }
}

public class F3RotatoryWheel: UIControl {
    
    public var delegate: F3RotatoryWheelProtocol?
    var container: UIView?
    public var numberOfSections: Int = 0
    public var scale:CGFloat = 1.5
    var offset = 0
    public var imageNames : [String] = []
    public var isSemiCircle = false
    public var itemSize : CGSize = CGSize(width: 70, height: 70)
    public var rotateWheelByOffset : CGFloat = 0.1
    private var customImages: [CustomImageView] = []
    
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
    
    required public init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    static  var minAlphavalue: CGFloat = 0.6
    static  var maxAlphavalue: CGFloat = 1.0
    
    public func reloadView(){
        if isSemiCircle{
            self.imageNames = imageNames + imageNames
        }
        
        container?.removeFromSuperview()
        container = nil
        
        customImages.removeAll()
        drawWheel()
    }
    
    func drawWheel() {
        // 1
        var _frame = frame;
        _frame.origin = CGPoint(x: 0, y: 0)
        container = UIView (frame: _frame)
        offset = Int(ceil(Double(numberOfSections)/4.0))
        currentSector = numberOfSections - offset
        // 2 this is a class property now, not just a variable in the method
        //let angleSize = CGFloat (2 * Double.pi ) / CGFloat ( numberOfSections );
        // 3
        for i in 0..<numberOfSections {
            
            // 4 - Create image view
            let imFrame = CGRect(x: 0, y: 0, width: container!.bounds.size.width/2, height: container!.bounds.size.width/2*7/10.4)
            let im = UIView(frame: imFrame)
            im.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            im.layer.position = CGPoint(x: container!.bounds.size.width/2,
                                        y: container!.bounds.size.height/2)
            im.transform = CGAffineTransform(rotationAngle: CGFloat ( angleSize ) * CGFloat (i)  );
            im.tag = i;
            // 5 - Set sector image
            let sectorImage = CustomImageView ( frame: CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height))
            sectorImage.transform = CGAffineTransform(rotationAngle: CGFloat(90 * Double.pi/180));
            
            let imgName = imageNames[i]
            sectorImage.image = UIImage (named: imgName)
            sectorImage.tag = i
            im.addSubview (sectorImage)
            // 6 - Add image view to container
            container!.addSubview (im)
            customImages.append(sectorImage)
            
            positionCustomImage(image: sectorImage, tag: sectorImage.tag)
            
            if (i == currentSector) {
                sectorImage.transform = sectorImage.transform.scaledBy(x: scale, y: scale)
            }
        }
        
        // 7
        container!.isUserInteractionEnabled = false;
        
        addSubview (container!)
        
        let t = container!.transform.rotated(by: rotateWheelByOffset)
        container!.transform = t
    }
    
    func positionCustomImage(image:CustomImageView, tag:Int){
        image.revertYTranslation()
        if (tag == currentSector) {
            image.applyYTranslation(value: -5)
            
        }
        else{
            
            if tag == nextTag(){
                image.applyYTranslation(value: -22)
            }
            else if tag == nextToNextTag(){
                image.applyYTranslation(value: -11)
            }
            else if tag == prevTag(){
                image.applyYTranslation(value: -24)
            }
            else if tag == prevToPrevTag(){
                image.applyYTranslation(value: -12)
            }
        }
    }
    
    func nextTag()->Int{
        var _nextTag = currentSector + 1
        if (_nextTag >= numberOfSections){
            _nextTag = numberOfSections%_nextTag
        }
        return _nextTag
    }
    
    func nextToNextTag()->Int{
        var _nextToNextTag = currentSector + 2
        if (_nextToNextTag >= numberOfSections){
            _nextToNextTag = numberOfSections%_nextToNextTag
        }
        return _nextToNextTag
    }
    
    func prevTag()->Int{
        var _prevTag = currentSector - 1
        if (_prevTag < 0){
            _prevTag = numberOfSections + _prevTag
        }
        return _prevTag
    }
    
    func prevToPrevTag()->Int{
        var _prevToPrevTag = currentSector - 2
        if (_prevToPrevTag < 0){
            _prevToPrevTag = numberOfSections + _prevToPrevTag
        }
        return _prevToPrevTag
    }
    
    func positionAllCustomImages(){
        for customImage in customImages{
            positionCustomImage(image: customImage, tag: customImage.tag)
        }
    }
    
    var currentSector: Int = 0
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1 - Get touch position
        let touchPoint = touch.location(in: self)
        // 2 - Calculate distance from center
        let dx = touchPoint.x - container!.center.x;
        let dy = touchPoint.y - container!.center.y;
        // 3 - Calculate arctangent value
        F3RotatoryWheel.deltaAngle = Float( atan2(dy,dx) );
        // 4 - Save current transform
        startTransform = container!.transform;
        
        // 5 - Set current sector's alpha value to the minimum value
        let im:UIView = getSectorByValue (currentSector)!
        for sectorImg in im.subviews{
            if sectorImg is CustomImageView{
                UIView.animate(withDuration: 0.25, animations: {
                    sectorImg.transform = sectorImg.transform.scaledBy(x:1/self.scale,y:1/self.scale)
                }, completion: nil)
                
            }
        }
        return true;
    }
    
    func getSectorByValue (_ value: Int) -> UIView? {
        var res: UIView?
        let views = container!.subviews
        for im in views {
            if im.tag == value {
                res = im; }
        }
        return res;
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        //let radians = atan2f(Float (  container!.transform.b  ), Float (  container!.transform.a)  )
        //print("rad is \(radians)")
        
        let pt = touch.location(in: self)
        let dx = pt.x  - container!.center.x
        let dy = pt.y  - container!.center.y
        let ang = Float ( atan2(dy,dx) )
        let angleDifference = F3RotatoryWheel.deltaAngle - ang
        container!.transform = startTransform.rotated( by: CGFloat ( -angleDifference)  )
        return true
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        // 1 - Get current container rotation in radians
        let radians = atan2f(Float (  container!.transform.b  ), Float (  container!.transform.a)  )
        // 2 Determine which sector is now selected
        currentSector = calculateNewSector (radians)
        //let centerSelected = angleSize / 2 + Double ( currentSector ) * angleSize
        //print ("currents degrees = \(radians * 57.3)")
        //print ("currents segCenter degrees = \(centerSelected * 57.3)")
        
        let sign: Float = radians < 0 ? -1 : 1
        var rad2 = abs ( radians )
        while rad2 > Float ( angleSize ) {
            rad2 = rad2 - Float ( angleSize )
        }
        
        if rad2 > Float ( angleSize / 2 ) {
            rad2 = rad2 - Float ( angleSize  )
        }
        
        // 3 - Initialize new value
        let newVal = (rad2 * sign) - Float(rotateWheelByOffset) //centerSelected - Double ( radians ) // Double.pi/4.0;
        
        
        // 4 Rotate to the center of the selected sector
        
        // 7 - Set up animation for final rotation
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        let t = container!.transform.rotated(by: CGFloat(-newVal))
        container!.transform = t
        UIView.commitAnimations()
        
        // 12 - Position All Custom Image
        
        positionAllCustomImages()
        
        // 10 - Highlight selected sector
        if let im = getSectorByValue (currentSector) {
            for sectorImg in im.subviews{
                if sectorImg is UIImageView{
                    UIView.animate(withDuration: 0.25, animations: {
                        sectorImg.transform = sectorImg.transform.scaledBy(x: self.scale, y: self.scale)
                    }, completion: nil)
                    
                }
            }
        }
        
        // 11 - Report to the caller
        var currentValue = numberOfSections - currentSector
        if isSemiCircle
        {
            if currentValue > numberOfSections/2{
                currentValue = currentValue - numberOfSections/2
            }
        }
        
        
        
        delegate?.wheelDidChangeValue(newValue: String (currentValue))
    }
    
    func calculateNewSector (_ radians:Float) -> Int {
        let x =   Float ( angleSize / 2 + 2 * Double.pi ) - radians
        var sectorNum = Int (x / Float ( angleSize )  ) % numberOfSections
        
        
        sectorNum -= offset // to select the middle section
        if sectorNum < 0{
            sectorNum = numberOfSections + sectorNum
        }
        print(sectorNum)
        return sectorNum
    }
    
    func calculateDistanceFromCenter (point: CGPoint) ->  Float     {
        let center = CGPoint (x: bounds.size.width/2, y: bounds.size.height/2)
        let dx = point.x - center.x;
        let dy = point.y - center.y;
        return Float ( sqrt(dx*dx + dy*dy) );
    }

    
}

