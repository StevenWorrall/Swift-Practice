//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    private let topLeftView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .red
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let topRightView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .blue
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let bottomLeftView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .green
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let bottomRightView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .yellow
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let centerView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .orange
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        self.setupConstraints()
    }
    
    func addViews() {
        self.view.addSubview(self.topLeftView)
        self.view.addSubview(self.topRightView)
        self.view.addSubview(self.bottomLeftView)
        self.view.addSubview(self.bottomRightView)
        self.view.addSubview(self.centerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.topLeftView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.topLeftView.widthAnchor.constraint(equalToConstant: 80),
            self.topLeftView.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.topRightView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.topRightView.widthAnchor.constraint(equalToConstant: 80),
            self.topRightView.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.bottomLeftView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.bottomLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.bottomLeftView.widthAnchor.constraint(equalToConstant: 80),
            self.bottomLeftView.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.bottomRightView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.bottomRightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.bottomRightView.widthAnchor.constraint(equalToConstant: 80),
            self.bottomRightView.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerView.widthAnchor.constraint(equalToConstant: 80),
            self.centerView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
