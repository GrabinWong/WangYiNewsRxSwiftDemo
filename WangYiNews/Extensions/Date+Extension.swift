import UIKit

extension Date {
    var timeStamp: Int {
        return Int(self.timeIntervalSince1970)
    }
}
