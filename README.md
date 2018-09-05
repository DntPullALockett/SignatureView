# SignatureView
This repo is to use digital signature view in iOS app (Swift / ObjectiveC)
To provide Digital Signature View in Swift / ObjectiveC Apps. Where user can draw signature and use it in the app (for example : sign any document)
This view has three buttons :
1. Reset - to reset the signature.
2. Resize - to change the size of signature view by dragging.
3. Done - to get the image of signature that can be used in App.


## Installation can be done via CocoaPods / Carthage.


**1. CocoaPods**

     pod 'SignatureSDK'

**2. Carthage**

     github "SharadGoyal/SignatureView"

### Steps to use this framework :
1. *Import “Sign” framework in your file (e.g. import Sign)*
2. *Make an object of Configuration class. (e.g. let config = Configuration())*
3. *To customise the look & feel of Signature view, set the properties of Configuration class.*
4. *Initialise SignatureView with configuration object and a closure to get image of signature.*

```  
@objc public class Configuration : NSObject {

    /// label placeholder text
    @objc public var placeholderText: String

    /// reset button title
    @objc public var resetBtnTitle: String

    /// resize button title
    @objc public var resizeBtnTitle: String

    /// done button title
    @objc public var doneBtnTitle: String

    /// buttons background color
    @objc public var btnBackgroundColor: UIColor

    /// buttons title color
    @objc public var btnTitleColor: UIColor

    /// to specify signature color
    @objc public var signatureColor: UIColor

    /// to specify signature line width
    @objc public var signatureWidth: CGFloat

    /// label text color
    @objc public var labelTextColor: UIColor

    /// label and button font name
    @objc public var fontName: String

    /// to draw rounded button
    @objc public var showRounded: Bool

    /// to enable Gradiant Color
    @objc public var enableGradiant: Bool

    /// array of gradient colors
    @objc public var gradientColors: [UIColor]

    /// gradient color direction
    @objc public var gradientDirection: GradientDirection

    /// UIButton press effect type
    @objc public var buttonPressEffectType: PressEffectType

    /// UIButton border color
    public var btnBorderColor: UIColor

    /// UIButton corner radius
    @objc public var btnCornerRadius: CGFloat

    /// UIButton border width
    @objc public var btnBorderWidth: CGFloat
}
```

### Basic Code Example :

```
     
import UIKit
import Sign

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clickedBtn(_ sender: UIButton) {
        var config = Configuration()
        config.placeholderText = "Type Here"
        config.btnBackgroundColor = UIColor.blue
        config.enableGradiant = true
        config.showRounded = true
        let _ = SignatureView.init(config: config) { (image) in
            print("image received...")
        }
    }
}
```
