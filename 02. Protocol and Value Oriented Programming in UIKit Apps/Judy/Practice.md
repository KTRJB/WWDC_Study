```swift
class MoviewViewController: UIViewController {
//    var movies: [Movie]
//    var images: [UIImage]
    var model: Model?
    
    var state: ViewMode = .view
}

enum ViewMode {
    case view
    case isLoading
    case isError
    case noNetwork
}

struct Movie {
    let name: String
}

struct Model {
    var movies: [Movie]
    var images: [UIImage]
}


struct LayoutConstraint {
    func setup(_ view: View, with superView: View) {
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superView.leftAnchor),
            view.rightAnchor.constraint(equalTo: superView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            view.topAnchor.constraint(equalTo: superView.topAnchor),
        ])
    }
}

extension UIView: View { }

protocol View {
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
}

final class AddCollectionViewCell: UICollectionViewCell {
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    // MARK: - Methods
    private func setupConstraints() {
        self.contentView.addSubview(productImage)
        
//        NSLayoutConstraint.activate([
//            productImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
//            productImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
//            productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//        ])
        
        let layoutConstraint = LayoutConstraint()
        layoutConstraint.setup(productImage, with: contentView)
    }
}
```
