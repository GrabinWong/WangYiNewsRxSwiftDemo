import RxDataSources

struct NewsSections {
    var header: String?
    var items: [NewsModel]
}

extension NewsSections: SectionModelType {
    typealias Item = NewsModel

    init(original: NewsSections, items: [NewsModel]) {
        self = original
        self.items = items
    }
    
}
