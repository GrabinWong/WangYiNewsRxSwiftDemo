import UIKit
import SnapKit
import Kingfisher

class OneImageNewsTableViewCell: UITableViewCell {
    private lazy var newsImageView: UIImageView = {
        return UIImageView(frame: .zero)
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.numberOfLines = 2
        return label
    }()

    private lazy var source: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setup(_ news: NewsModel) {
        var imgsrc = ""
        if news.imgsrc.hasPrefix("http:") {
            imgsrc = news.imgsrc.replacingOccurrences(of: "http:", with: "https:")
        }
        let url = URL(string: imgsrc)
        newsImageView.kf.setImage(with: url, placeholder:  UIImage(named: "placeholder"))
        title.text = news.title
        source.text = news.source
    }

    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(title)
        contentView.addSubview(source)

        newsImageView.snp.makeConstraints { make in
            make.width.equalTo(120.0)
            make.height.equalTo(80.0)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-10.0)
        }

        title.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).offset(10.0)
            make.trailing.equalTo(newsImageView.snp_leadingMargin).offset(-10.0)
        }

        source.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.bottom.equalTo(contentView).offset(-10.0)
            make.height.equalTo(15.0)
        }
    }
    
}
