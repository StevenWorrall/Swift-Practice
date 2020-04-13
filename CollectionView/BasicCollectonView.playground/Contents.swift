//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private let cellID = "myCellID"
    
    private let collectonView: UICollectionView = {
        let tempLayout = UICollectionViewFlowLayout()
        tempLayout.scrollDirection = .vertical
        let tempCollection = UICollectionView(frame: .zero, collectionViewLayout: tempLayout)
        tempCollection.backgroundColor = .clear
        tempCollection.translatesAutoresizingMaskIntoConstraints = false
        return tempCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.collectonView.delegate = self
        self.collectonView.dataSource = self
        
        self.collectonView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
        
        self.view.addSubview(self.collectonView)
        NSLayoutConstraint.activate([
            self.collectonView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
        
        cell.backgroundColor = .blue
        
        return cell
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
