import RxSwift
import RxCocoa

class NewsViewModel: NSObject {
    // input
    let offset = Variable("")
    
    // output
    var newsData: Driver<[NewsSections]> {
        return offset.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(NewsDataManager.shared.getNews)
            .asDriver(onErrorJustReturn: [])
    }

}
