//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)

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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cellId")
        let dataForCell = data[indexPath.row]
        
        cell.textLabel?.text = dataForCell.name
        cell.detailTextLabel?.text = dataForCell.artistName
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        cell.selectionStyle = .none
        
        return cell
    }
}

class MyTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
