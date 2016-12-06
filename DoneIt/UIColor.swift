import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func themeA() -> UIColor {
        return UIColor.init(netHex: 0x05668D)
    }
    
    static func themeB() -> UIColor {
        return UIColor.init(netHex: 0x028090)
    }
    
    static func themeC() -> UIColor {
        return UIColor.init(netHex: 0x00A896)
    }
    
    static func themeD() -> UIColor {
        return UIColor.init(netHex: 0x02C39A)
    }
    
    static func themeE() -> UIColor {
        return UIColor.init(netHex: 0xF0F3BD)
    }
}

