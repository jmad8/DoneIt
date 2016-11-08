import UIKit

@IBDesignable
class MultiLineTextField: UITextView, UITextViewDelegate, UIScrollViewDelegate, TextInputStylable {
    
    private var _placeholderIsVisible = true
    private var _defaultTextColor : UIColor!
    private var _defaultTextFont : UIFont?
    
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
    
    @IBInspectable var borderWidth : CGFloat = CGFloat(2.0) {
        didSet {
            updateBorderFrame()
        }
    }
    
    @IBInspectable var placeholder : String = "" {
        didSet{
            if _placeholderIsVisible {
                textColor = placeholderTextColor
                text = placeholder
            }
        }
    }
    
    @IBInspectable var placeholderTextColor : UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15) {
        didSet {
            if _placeholderIsVisible {
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if _placeholderIsVisible && isFirstResponder {
            text = nil
            textColor = _defaultTextColor
            font = _defaultTextFont
            _placeholderIsVisible = false
        }
        updateBorderColor(withColor: borderColorFocus)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == nil || text.isEmpty {
            _placeholderIsVisible = true
            textColor = placeholderTextColor
            font = UIFont(name: "Helvetica Neue", size: 17)
            text = placeholder
        }
        updateBorderColor(withColor: borderColor)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBorderFrame(x: -scrollView.contentOffset.y)
    }
}
