import UIKit

@IBDesignable
class CustomTextField: UITextField, UITextFieldDelegate, TextInputStylable {
    
    private var _originalPlaceholder : String?
    
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
    
    @IBInspectable var borderWidth : CGFloat = CGFloat(1.0) {
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
        _originalPlaceholder = placeholder
        
        borderStyle = .none
        self.delegate = self
        addBorderLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholder = nil
        updateBorderColor(withColor: borderColorFocus)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        placeholder = _originalPlaceholder
        updateBorderColor(withColor: borderColor)
    }
    
}
