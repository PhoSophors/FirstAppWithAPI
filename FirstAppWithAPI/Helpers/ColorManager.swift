import UIKit

class ColorManager {
    static let shared = ColorManager() // Singleton instance

    private init() {}

    func IVORY() -> UIColor {
        return UIColor(hex: "#E1DAD3")
    }
  
    func NUDE() -> UIColor {
        return UIColor(hex: "#E4C9B6")
    }

    func DUSTYROSE() -> UIColor {
        return UIColor(hex: "#D7A49A")
    }
    
    func SAGE() -> UIColor {
        return UIColor(hex: "#D7A49A")
    }
    
    func BABYBLUE() -> UIColor {
        return UIColor(hex: "#A4B1BA")
    }

    // Add more color methods as needed
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
