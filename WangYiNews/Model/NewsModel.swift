import UIKit

struct NewsModel {
    var title: String
    var imgsrc: String
    var replyCount: String
    var source: String
    var imgnewextra: [Imgnewextra]?
}

struct Imgnewextra {
    var imgsrc: String
}
