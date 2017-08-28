# FooyoTestSDK

Fooyo SDK for OSP

# Installation

## Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SnapKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Pushian/FooyoTestSDK"
```

Run `carthage update` to build the framework and drag the following built 
`Alamofire.framework`
`AlamofireImage.framework`
`Mapbox.framework`
`SwiftyJSON.framework`
`SVProgressHUD.framework`
`SnapKit.framework`
`TGPControls.framework`
`FooyoTestSDK.framework`
as well as the bundle file `FooyoSDK.bundle` inside `FooyoTestSDK.framework`
into your Xcode project.

# Usage

## General SDK Parameters

- `category`: Category Name (`String Value`);
- `levelOneId`: The id for all the categories except the `Hotspots` of `Non-linear Trails` (`Int Value`);
- `levelTwoId`: The id for all the `Hotspots` of `Non-linear Trails` (`Int Value`)

Only `Hotspots` of `Non-linear Trails` will have `levelTwoId`. Their `levelOneId` is `Non-linear Trail` Id.

## BaseMap SDK

### Initialization

```swift
let vc = FooyoBaseMapViewController(category: String?, levelOneId: Int?)
vc.delegate = self
```

### SDK Variables

Both of the two variables `category` and `levelOneId` are **optional**:

- To show all the locations belong to a specific category, please specify the category name only;
- To show a specific location, please specify the category name and the id of this location;
- To show all the locations, please do not sepcify any of them.

### Delegate Function

Delegate Prototal: `FooyoBaseMapViewControllerDelegate`.

Delegate Function:

```swift
func didTapInformationWindow(category: String, levelOneId: Int, levelTwoId: Int?) {
        debugPrint(category)
        debugPrint(levelOneId)
        debugPrint(levelTwoId)
    }
```

This function will be called when the information window is clicked.

## Navigation SDK

### Initialization

```swift
let vc = FooyoNavigationViewController(startCategory: String?, startLevelOneId: Int? startLevelTwoId: Int?, endCategory: String?, endLevelOneId: Int?, endLevelTwoId: Int?)
```

### SDK Variables

- `startCategory`: category name of the start location (**optional**);
- `startLevelOneId`: level one category id of the start location (**optional**);
- `startLevelTwoId`: level two category id of the start location (**optional**);
- `endCategory`: category name of the end location (**compulsory**);
- `startLevelOneId`: level one category id of the end location (**compulsory**);
- `startLevelTwoId`: level two category id of the end location (**optional**).

When the starting point is unspecified, the user's current location will be considered as the starting point.

## My Plans SDK

### Initialization

```swift
let vc = FooyoBaseMapViewController()
```

## Add To Plan SDK

### Initialization

```swift
let vc = FooyoAddToPlanViewController(category: String, levelOneId: Int)
```

### SDK Variables

- `category`: category name of the location (**compulsory**);
- `levelOneId`: level one category id of the location (**compulsory**);

