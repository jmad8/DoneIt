import UIKit

protocol TextInputStylable {
    var border : UIView { get set }
    var borderWidth : CGFloat { get set }
    var borderColor : UIColor { get set }
    var borderColorFocus : UIColor { get set }
    
    func addBorderLayer()
    func updateBorderFrame(x : CGFloat)
    func updateBorderColor(withColor color : UIColor)
}

extension TextInputStylable where Self : UIView {
    
    func addBorderLayer() {
        border.backgroundColor = borderColor
        updateBorderFrame()
        addSubview(border)
    }
    
    func updateBorderFrame(x : CGFloat = 0) {
        border.frame = CGRect(x: 0, y: self.frame.size.height-borderWidth - x, width: self.frame.size.width, height: borderWidth)
    }
    
    func updateBorderColor(withColor color : UIColor) {
        border.layer.backgroundColor = color.cgColor
    }
}
