//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageUsingUrlString(_ urlString: String) {
        let url = URL(string: urlString)
        imageUrlString = urlString
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }.resume()
    }
}

struct Album: Decodable {
    let id: String
    let artistName: String?
    let name: String?
    let artworkUrl100: String?
    let url: String?
}

struct Feed: Decodable {
    let id: String
    let title: String?
    let results: [Album]?
}

struct FeedResponse: Decodable {
    let feed: Feed
}

class Service {
    let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.json"

    public func fetchGenericData<T: Decodable>(completion: @escaping ((Result<T, Error>) -> () )) {
        // can add a completion here and return custom error struct
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }

            do {
                let dataResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(dataResponse))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

class MyViewController : UIViewController {
    private let cellID = "myCellID"
    private let serviceClass = Service()
    private var data: [Album] = []
    
    private let collectonView: UICollectionView = {
        let tempLayout = UICollectionViewFlowLayout()
        tempLayout.scrollDirection = .horizontal
        tempLayout.minimumLineSpacing = 0.0
        tempLayout.minimumInteritemSpacing = 0.0
        let tempCollection = UICollectionView(frame: .zero, collectionViewLayout: tempLayout)
        tempCollection.backgroundColor = .clear
        tempCollection.translatesAutoresizingMaskIntoConstraints = false
        tempCollection.isPagingEnabled = true
        return tempCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        getData()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.collectonView.delegate = self
        self.collectonView.dataSource = self
        
        self.collectonView.register(MyCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        
        self.view.addSubview(self.collectonView)
        NSLayoutConstraint.activate([
            self.collectonView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func reloadViews() {
        DispatchQueue.main.async {
            self.collectonView.reloadData()
        }
    }
    
    private func getData() {
        serviceClass.fetchGenericData{ [weak self] (result: Result<FeedResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let resultData = data.feed.results else { return }
                self.data = resultData
                self.reloadViews()
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! MyCollectionCell
        let dataForCell = data[indexPath.row]
        
        cell.url = dataForCell.artworkUrl100
        cell.topLabel.text = dataForCell.name
        cell.bottomLabel.text = dataForCell.artistName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
}

class MyCollectionCell: UICollectionViewCell {
    private let spacingConstant:CGFloat = 10
    
    public var url: String? {
        didSet {
            if let unwrappedURL = self.url {
                self.customImageView.loadImageUsingUrlString(unwrappedURL)
            }
        }
    }
    private let customImageView: CustomImageView = {
        let temp = CustomImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    public let topLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = .black
        temp.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    public let bottomLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = .darkGray
        temp.font = UIFont.systemFont(ofSize: 16, weight: .light)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .white
        
        self.addSubview(customImageView)
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.spacingConstant),
            customImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.addSubview(topLabel)
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: self.spacingConstant),
            topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.spacingConstant),
            topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        self.addSubview(bottomLabel)
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.spacingConstant),
            bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.spacingConstant),
            bottomLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
