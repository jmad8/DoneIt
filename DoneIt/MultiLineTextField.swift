import UIKit

@IBDesignable
class MultiLineTextField: UITextView, UITextViewDelegate, UIScrollViewDelegate, TextInputStylable {
    
    
    private var _defaultTextColor : UIColor!
    private var _defaultTextFont : UIFont?
    public var placeholderIsVisible = true
    public var border : UIView = UIView()
    
    @IBInspectable var borderColor : UIColor = UIColor.red {
        didSet {
            border.layer.backgroundColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderColorFocus : UIColor = UIColor.green {
        didSet {
            border.layer.backgroundColor = borderColorFocus.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = CGFloat(1.0) {
        didSet {
            updateBorderFrame()
        }
    }
    
    @IBInspectable var placeholder : String = "" {
        didSet{
            if placeholderIsVisible {
                textColor = placeholderTextColor
                text = placeholder
            }
        }
    }
    
    @IBInspectable var placeholderTextColor : UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15) {
        didSet {
            if placeholderIsVisible {
                textColor = placeholderTextColor
            }
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.clear {
        didSet {
            backgroundColor = color
        }
    }
    
    override var bounds: CGRect{
        didSet{
            updateBorderFrame()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        backgroundColor = color
        textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0)
        _defaultTextColor = textColor
        _defaultTextFont = font
        autocapitalizationType = .sentences
        self.delegate = self
        addBorderLayer()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if placeholderIsVisible && isFirstResponder {
            text = nil
            textColor = _defaultTextColor
            font = _defaultTextFont
            placeholderIsVisible = false
        }
        updateBorderColor(withColor: borderColorFocus)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == nil || text.isEmpty {
            placeholderIsVisible = true
            textColor = placeholderTextColor
            font = UIFont(name: "Helvetica Neue", size: 17)
            text = placeholder
        }
        updateBorderColor(withColor: borderColor)
    }
}
