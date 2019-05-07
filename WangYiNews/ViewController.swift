import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshItem: UIBarButtonItem!
    
    private let viewModel = NewsViewModel()
    
    private let offset = Variable("0")
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<NewsSections>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let output = viewModel.transform(input: offset, dependecies: NewsDataManager.shared)
        
        dataSource = RxTableViewSectionedReloadDataSource<NewsSections>(configureCell: { dataSource, tableView, indexpath, item  in
            if item.imgnewextra?.isEmpty ?? true,
                let cell = tableView.dequeueReusableCell(withIdentifier: "OneImageNewsTableViewCell", for: indexpath) as? OneImageNewsTableViewCell {
                cell.setup(item)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeImagesTableViewCell", for: indexpath) as? ThreeImagesTableViewCell {
                cell.setup(item)
                return cell
            }
            return UITableViewCell()
        })
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        refreshItem.rx.tap.bind {
            let offset = Int(self.offset.value) ?? 0
            self.offset.value = "\(offset + 10)"
        }.disposed(by: disposeBag)
        
    }
    
    private func setupTableView() {
        tableView.register(OneImageNewsTableViewCell.self, forCellReuseIdentifier: "OneImageNewsTableViewCell")
        tableView.register(ThreeImagesTableViewCell.self, forCellReuseIdentifier: "ThreeImagesTableViewCell")
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsSection = dataSource.sectionModels[indexPath.section]
        let news = newsSection.items[indexPath.row]
        if news.imgnewextra?.isEmpty ?? true {
            return 100.0
        }
        return 180.0
    }
}

