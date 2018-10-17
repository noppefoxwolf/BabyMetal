# [Archive] BabyMetal

[![CI Status](https://img.shields.io/travis/noppefoxwolf/BabyMetal.svg?style=flat)](https://travis-ci.org/noppefoxwolf/BabyMetal)
[![Version](https://img.shields.io/cocoapods/v/BabyMetal.svg?style=flat)](https://cocoapods.org/pods/BabyMetal)
[![License](https://img.shields.io/cocoapods/l/BabyMetal.svg?style=flat)](https://cocoapods.org/pods/BabyMetal)
[![Platform](https://img.shields.io/cocoapods/p/BabyMetal.svg?style=flat)](https://cocoapods.org/pods/BabyMetal)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```
var source = ImageSource(name: "example")
var filter = BlurFilter()
var preview = PreviewView(frame: view.bounds, device: MTLCreateSystemDefaultDevice()!)

source >>> filter >>> preview
```

## Requirements

## Installation

BabyMetal is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BabyMetal'
```

## Author

noppefoxwolf, noppelabs@gmail.com

## License

BabyMetal is available under the MIT license. See the LICENSE file for more info.
