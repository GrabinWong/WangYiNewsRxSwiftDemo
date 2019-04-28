import UIKit

extension String {
    var legalUrlString: String? {
        if self.hasPrefix("http:") {
            return self.replacingOccurrences(of: "http:", with: "https:")
        }
        return nil
    }
}
