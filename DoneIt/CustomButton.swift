import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var radius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var background : UIColor = UIColor.clear {
        didSet{
            backgroundColor = background
        }
    }
    
}
