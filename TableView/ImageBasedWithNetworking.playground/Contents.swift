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
    
    private let tableView: UITableView = {
        let temp = UITableView(frame: .zero, style: UITableView.Style.plain)
        temp.backgroundColor = .clear
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.separatorStyle = .singleLine
        temp.tableFooterView = UIView()
        return temp
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupTableView()
        self.getData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: self.cellID)

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func reloadViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) as! MyTableViewCell
        let dataForCell = data[indexPath.row]
        
        cell.url = dataForCell.artworkUrl100
        cell.topLabel.text = dataForCell.name ?? "Unknonwn"
        cell.bottomLabel.text = dataForCell.artistName ?? "Unknonwn"
        cell.selectionStyle = .none
        
        return cell
    }
}

class MyTableViewCell: UITableViewCell {
    private let spacingConstant:CGFloat = 10
    
    public var url: String? {
        didSet {
            if let unwrappedURL = self.url {
                self.customImageView.loadImageUsingUrlString(unwrappedURL)
            }
        }
    }
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
    private let customImageView: CustomImageView = {
        let temp = CustomImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(customImageView)
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.spacingConstant),
            customImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            customImageView.heightAnchor.constraint(equalToConstant: self.bounds.width),
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
