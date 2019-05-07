import RxSwift
import RxCocoa

class NewsViewModel: NSObject {
    // input
    private var offset = Variable("")

    func transform(input: (Variable<String>), dependecies: (NewsDataManager)) -> Driver<[NewsSections]> {
        self.offset = input
        return offset.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(dependecies.getNews)
            .asDriver(onErrorJustReturn: [])
    }

}
