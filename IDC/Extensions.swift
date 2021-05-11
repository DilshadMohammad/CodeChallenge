import UIKit
extension UIView {

    func dropShadow(color: UIColor = .gray, opacity: Float = 0.5, offSet: CGSize = CGSize.zero, radius: CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset =  CGSize.zero
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
}
extension Date {
    static func getFormattedDate(string: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date: Date? = dateFormatterGet.date(from: string)
        dateFormatterGet.dateFormat = "EEE, dd MMM yyyy HH:mm a"
        return dateFormatterGet.string(from: date!)
    }
}
