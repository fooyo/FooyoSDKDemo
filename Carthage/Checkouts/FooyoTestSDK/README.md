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
`CoreActionSheetPicker`
`JVFloatLabeledText`
`TPKeyboardAvoidingKit`
`FooyoTestSDK.framework`
as well as the bundle file `FooyoSDK.bundle` inside `FooyoTestSDK.framework`
into your Xcode project.

# Usage

```swift
import FooyoTestSDK
```

## SDK Demo Project

[A Demo Project](https://github.com/fooyo/FooyoSDKDemo/tree/master) is created specically for the OSP project to demostrate how to integrate Fooyo's SDK.

## General SDK Parameters

```swift
public class FooyoIndex: NSObject {
    var category: String?
    var levelOneId: String?
    var levelTwoId: String?
}
```
`FooyoIndex` is designed for an easy communication between the base system and the SDK functions. For all the locations, trails and the hotspots of the trails, they would have their own `FooyoIndex` for a better reference. `FooyoIndex` incldues the following parameters:

- `category`: Category Name (`String Value`);
- `levelOneId`: The id for all the locations and trails (`Int Value`);
- `levelTwoId`: The hotspot id for all the `Hotspots` of `Non-linear Trails` (`Int Value`)

Only `Hotspots` of `Non-linear Trails` will have `levelTwoId`. Their `levelOneId` is the `Non-linear Trail` Id.

## General SDK Functions

### Session Activation

```swift 
FooyoSDKOpenSession()
```

`GUIDE` Call this function whenever the app becomes active. All the data required by Fooyo SDK will be loaded at the background.

### User Login

```swift
FooyoSDKSignIn(userId: String)
```
`GUIDE` Call this function whenever the app achieves the user Id. All the user related data required by Fooyo SDK will be loaded at the background.

### User Logout

```swift
FooyoSDKSignOut()
```
`GUIDE` Call this function whenever the app achieves the user Id. All the user related data locally saved by Fooyo SDK will be removed.

### Add Location To Plan From The Detail Page
```swift
FooyoSDKAddToTheEditingPlan(index: FooyoIndex)
```
#### When To Call?

- Everytime Fooyo sends a call back function, it will pass back two parameters, one is `FooyoIndex`, and the other is `isEditingAPlan`;
- When the base system opens the detail page reacting to the call back function, please take both parameters;
- When the Heart Button is clicked in the detail page:
    - if the `isEditingAPlan` is false, call the Fooyo SDK function `FooyoAddToPlanViewController(index: FooyoIndex, userId: String)`
    - if it is true, call the Fooyo SDK function `FooyoSDKAddToTheEditingPlan(index: FooyoIndex)`

## BaseMap SDK

### Initialization

```swift
let vc = FooyoBaseMapViewController(index: FooyoIndex?, hideTheDefaultNavigationBar: Bool)
vc.delegate = self
```

### Variables

- For this function, the input parameter `FooyoIndex` would only inclue `categroy` and `levelOneId`. This function won't consider the `levelTwoId`, which means it can not be used to show a specific hotspot (of a non-linear trail) on the map.

- `hideTheDefaultNavigationBar` is used to define whether the navigation bar should be hidden or not for the map view.

### Usage

- To show all the locations belong to a specific category, please specify the category name only：

```swift
let index = FooyoIndex(category: String)
let vc = FooyoBaseMapViewController(index: FooyoIndex?)
```

- To show a specific location/trail, please specify the category name and the level one id of this location/trail:

```swift
let index = FooyoIndex(category: String, levelOneId: Int)
let vc = FooyoBaseMapViewController(index: FooyoIndex?)
```

- To show all the locations/trails, please do not sepcify the index:

```swift
let vc = FooyoBaseMapViewController()
```

### Delegate Function

Delegate Prototal: `FooyoBaseMapViewControllerDelegate`.

Delegate Function:

```swift
func fooyoBaseMapViewController(didSelectInformationWindow index: FooyoIndex, isEditingAPlan: Bool) {
        debugPrint(isEditingAPlan)
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        debugPrint(index.levelTwoId)
}
```

This function will be called when the pop-up information window is clicked:

## My Plans SDK

### Initialization

```swift
let vc = FooyoMyPlanViewController(userId: String?)
vc.delegate = self
```

### Delegate Function

Delegate Prototal: `FooyoMyPlanViewControllerDelegate`.

Delegate Function:

```swift
func fooyoMyPlanViewController(didSelectInformationWindow index: FooyoIndex, isEditingAPlan: Bool) {
        debugPrint(isEditingAPlan)
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        debugPrint(index.levelTwoId)
}
```

## Add To Plan SDK

### Initialization

```swift
let vc = FooyoAddToPlanViewController(index: FooyoIndex, userId: String)
let nav = UINavigationController(rootViewController: vc)
nav.navigationBar.isHidden = true
nav.modalPresentationStyle = .overFullScreen
self.present(nav, animated: true, completion: nil)
```

### SDK Variables

- `index`: FooyoIndex of the location/trail intended to be added to a specific plan (**compulsory**);

- `userId`: Required to fetch the existing plans (**compulsory**);


### Delegate Function

Delegate Prototal: `FooyoAddToPlanViewControllerDelegate`.

Delegate Function:

```swift
func fooyoAddToPlanViewController(didSelectInformationWindow index: FooyoIndex, isEditingAPlan: Bool) {
        debugPrint(isEditingAPlan)
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        debugPrint(index.levelTwoId)
}
```


## Upcoming SDK Functions

- To support that the user can open the location detail page within the plan editing pages and add the location into the **currently editing** plan using the "add" button;

## Navigation SDK

### Initialization

```swift
let vc = FooyoNavigationViewController(startIndex: FooyoIndex?, endIndex: FooyoIndex?)
```

### SDK Variables

- `startIndex`: FooyoIndex of the start location (**optional**);

- `endIndex`: FooyoIndex of the end location (**optional**);


When the `startIndex` is unspecified, the user's current location will be considered as the starting point.


## Create Plan SDK

### Initialization

```swift
let vc = FooyoCreatePlanViewController(userId: String)
vc.delegate = self
let nav = UINavigationController(rootViewController: vc)
self.present(nav, animated: true, completion: nil)
```

### SDK Variables

- `userId`: The unique ID for each user (**compulsory**);

### Delegate Function

Delegate Prototal: `FooyoCreatePlanViewControllerDelegate`.

Delegate Function:

```swift
func fooyoCreatePlanViewController(didCanceled success: Bool) {
    debugPrint(success)
}

func fooyoCreatePlanViewController(didSaved success: Bool) {
    debugPrint(success)
}
```
