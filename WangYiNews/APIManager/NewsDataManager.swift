import RxCocoa
import RxSwift
import Moya
import Alamofire
import SwiftyJSON

class NewsDataManager: NSObject {
    
    static let shared = NewsDataManager()
    
    private let provider = MoyaProvider<NewsMoya>()
    
    func getNews(_ offset: String) -> Observable<[NewsSections]> {
        return Observable<[NewsSections]>.create ({ observable in
            self.provider.request(.news(offset), callbackQueue: DispatchQueue.main) { response in
                switch response {
                case let .success(results):
                    let news = self.parse(results.data)
                    observable.onNext(news)
                    observable.onCompleted()
                case let .failure(error):
                    observable.onError(error)
                }
            }
            return Disposables.create()
        })
    }
    
    func parse(_ data: Any) -> [NewsSections] {
        guard let json = JSON(data)["T1348649079062"].array else { return [] }
        var news: [NewsModel] = []
        json.forEach {
            guard !$0.isEmpty else { return }
            var imgnewextras: [Imgnewextra] = []
            if let imgnewextraJsonArray = $0["imgnewextra"].array {
                imgnewextraJsonArray.forEach {
                    let subItem = Imgnewextra(imgsrc: $0["imgsrc"].string ?? "")
                    imgnewextras.append(subItem)
                }
            }
            let new = NewsModel(title: $0["title"].string ?? "", imgsrc: $0["imgsrc"].string ?? "", replyCount: $0["replyCount"].string ?? "", source: $0["source"].string ?? "", imgnewextra: imgnewextras)
            
            news.append(new)
        }
        return [NewsSections(header: "1", items: news)]
    }

}


enum NewsMoya {
    case news(_ offset: String)
}


extension NewsMoya: TargetType {
    var baseURL: URL {
        return URL(string: "https://c.m.163.com")!
    }
    
    var path: String {
        return "/dlist/article/dynamic"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .news(offset):
            let parameters = ["from": "T1348649079062", "devId": "H71eTNJGhoHeNbKnjt0%2FX2k6hFppOjLRQVQYN2Jjzkk3BZuTjJ4PDLtGGUMSK%2B55", "version": "54.6", "spever": "false", "net": "wifi", "ts": "\(Date().timeStamp)", "sign": "BWGagUrUhlZUMPTqLxc2PSPJUoVaDp7JSdYzqUAy9WZ48ErR02zJ6%2FKXOnxX046I", "encryption": "1", "canal": "appstore", "offset": offset, "size": "10", "fn": "3"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "text/plain"]
    }
    
    
}
