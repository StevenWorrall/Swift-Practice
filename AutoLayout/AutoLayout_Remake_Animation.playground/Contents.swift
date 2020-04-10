//: A UIKit based Playground for presenting user interface

// https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private let animationDuration = 0.5
    private var squareOriginConstraints: [NSLayoutConstraint] = []
    
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
    private let resetButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .black
        temp.setTitle("Reset Squares", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.titleLabel?.font = .systemFont(ofSize: 20)
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
        self.view.addSubview(self.resetButton)
        self.view.addSubview(self.topLeftButton)
        self.view.addSubview(self.topRightButton)
        self.view.addSubview(self.bottomLeftButton)
        self.view.addSubview(self.bottomRightButton)
        self.view.addSubview(self.centerButton)
    }
    
    func addSelectors() {
        self.resetButton.addTarget(self, action: #selector(resetPressed), for: UIControl.Event.touchUpInside)
        
        self.topLeftButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.topRightButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.bottomLeftButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.bottomRightButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.centerButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.resetButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        squareOriginConstraints = [
            self.topLeftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topLeftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.topRightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            self.topRightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.bottomLeftButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -20),
            self.bottomLeftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.bottomRightButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -20),
            self.bottomRightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.centerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(squareOriginConstraints + [
            self.centerButton.widthAnchor.constraint(equalToConstant: 80),
            self.centerButton.heightAnchor.constraint(equalToConstant: 80),
            self.topLeftButton.widthAnchor.constraint(equalToConstant: 80),
            self.topLeftButton.heightAnchor.constraint(equalToConstant: 80),
            self.topRightButton.widthAnchor.constraint(equalToConstant: 80),
            self.topRightButton.heightAnchor.constraint(equalToConstant: 80),
            self.bottomLeftButton.widthAnchor.constraint(equalToConstant: 80),
            self.bottomLeftButton.heightAnchor.constraint(equalToConstant: 80),
            self.bottomRightButton.widthAnchor.constraint(equalToConstant: 80),
            self.bottomRightButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    func removeAllSquareConstraints() {
        NSLayoutConstraint.deactivate(
            self.squareOriginConstraints
        )
    }
    
    func addAllSquareConstraints() {
        NSLayoutConstraint.activate(
            self.squareOriginConstraints
        )
    }
    
    @objc private func resetPressed(_ sender: UIButton!) {
        self.removeAllSquareConstraints()
        
        UIView.animate(withDuration: self.animationDuration) {
            self.addAllSquareConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
