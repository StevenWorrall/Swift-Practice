//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private let animationDuration = 1.0
    
    private let topLeftButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .red
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let topRightButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .blue
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let bottomLeftButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .green
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let bottomRightButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .yellow
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    private let centerButton: UIButton = {
        let temp = UIButton()
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
        self.addSelectors()
        self.setupConstraints()
    }
    
    func addViews() {
        self.view.addSubview(self.topLeftButton)
        self.view.addSubview(self.topRightButton)
        self.view.addSubview(self.bottomLeftButton)
        self.view.addSubview(self.bottomRightButton)
        self.view.addSubview(self.centerButton)
    }
    
    func addSelectors() {
        self.topLeftButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)
        self.topRightButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)
        self.bottomLeftButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)
        self.bottomRightButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)
        self.centerButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.topLeftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topLeftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.topLeftButton.widthAnchor.constraint(equalToConstant: 80),
            self.topLeftButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.topRightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topRightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.topRightButton.widthAnchor.constraint(equalToConstant: 80),
            self.topRightButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.bottomLeftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.bottomLeftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.bottomLeftButton.widthAnchor.constraint(equalToConstant: 80),
            self.bottomLeftButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.bottomRightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.bottomRightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.bottomRightButton.widthAnchor.constraint(equalToConstant: 80),
            self.bottomRightButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            self.centerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerButton.widthAnchor.constraint(equalToConstant: 80),
            self.centerButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    @objc private func squarePressed(sender: UIButton!) {
        UIView.animate(withDuration: self.animationDuration, animations: {
            sender.transform = CGAffineTransform(rotationAngle: -0.999 * .pi)
        }) { (_) in
            UIView.animate(withDuration: self.animationDuration) {
                sender.transform = CGAffineTransform.identity
            }
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
