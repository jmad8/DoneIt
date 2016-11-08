import UIKit

@IBDesignable
class CustomTextField: UITextField, UITextFieldDelegate, TextInputStylable {
    
    @IBInspectable var borderColor : UIColor = UIColor.red {
        didSet {
            border.backgroundColor = borderColor
        }
    }
    
    @IBInspectable var borderColorFocus : UIColor = UIColor.green {
        didSet {
            border.backgroundColor = borderColorFocus
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = CGFloat(2.0) {
        didSet {
            updateBorderFrame()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            updateBorderFrame()
        }
    }
    
    var border = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15),
            NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 17)! // Note the !
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:attributes)
        
        borderStyle = .none
        self.delegate = self
        addBorderLayer()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBorderColor(withColor: borderColorFocus)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBorderColor(withColor: borderColor)
    }
    
}
