# RotatoryWheel

[![CI Status](https://img.shields.io/travis/habibali/RotatoryWheel.svg?style=flat)](https://travis-ci.org/habibali/RotatoryWheel)
[![Version](https://img.shields.io/cocoapods/v/RotatoryWheel.svg?style=flat)](https://cocoapods.org/pods/RotatoryWheel)
[![License](https://img.shields.io/cocoapods/l/RotatoryWheel.svg?style=flat)](https://cocoapods.org/pods/RotatoryWheel)
[![Platform](https://img.shields.io/cocoapods/p/RotatoryWheel.svg?style=flat)](https://cocoapods.org/pods/RotatoryWheel)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Features

1.  This pod allows you to rotatory wheel control as shown in image
2.  It can be rendered  as complete or semi circle
3. Selected Item can be extracted via delegate
4. Selected Item scale ratio can be controlled via scale variable

```
//You can initialize the wheel like this

let screenWidth = UIScreen.main.bounds.width
let containerWidth : CGFloat = screenWidth - 20 // can be any value
let wheel = SMRotaryWheel (frame: CGRect(x: (screenWidth - containerWidth)/2, y: -(containerWidth/2), width: containerWidth, height: containerWidth))
view.addSubview(wheel)

//or alternatively you can add the view in story board as in exmaple project and make its class F3RotatoryWheel
//Make sure you make the width and height equal
//To make it semicircular hide the other half from the screen by adjusting its constraints

//Then initialize the wheel like this

wheel.delegate = self
wheel.numberOfSections = 10
wheel.imageNames = [String](arrayLiteral: "icon0.png","icon1.png","icon2.png","icon3.png","icon4.png")
wheel.isSemiCircle = true
wheel.scale = 1.5
wheel.itemSize = CGSize(width: 70, height: 70) //Image size
wheel.rotateWheelByOffset = 0.1 //due to image size some time you have to tweak this offset when semi circle mode is selected
wheel.reloadView()


```

5. It supports both iPad and iPhone resolutions and in all orientations

## Requirements

```
Swift 4.1
XCode 9.3
```

## Installation

RotatoryWheel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RotatoryWheel'
```

## Author

Habib Ali, habibali@folio3.com

## License

RotatoryWheel is available under the MIT license. See the LICENSE file for more info.
