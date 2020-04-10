# Auto Layout Practice

### [Basic Auto Layout Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Auto_Layout/Basic_Auto_Layout.playground)

<a href="url"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/Basic_Auto_Layout.png" align="center" height=25% width=25% ></a>

```swift
private let topLeftView: UIView = {
    let temp = UIView()
    temp.backgroundColor = .red
    temp.translatesAutoresizingMaskIntoConstraints = false
    return temp
}()

self.view.addSubview(self.topLeftView)

NSLayoutConstraint.activate([
    self.topLeftView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
    self.topLeftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    self.topLeftView.widthAnchor.constraint(equalToConstant: 80),
    self.topLeftView.heightAnchor.constraint(equalToConstant: 80),
])
```

### [Basic Auto Layout with Animation Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Auto_Layout/Basic_Auto_Layout_Animation.playground)

<a href="url"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/Basic_Auto_Layout_Animation.gif" align="center" height=25% width=25% ></a>
```swift
self.topLeftButton.addTarget(self, action: #selector(squarePressed), for: UIControl.Event.touchUpInside)

UIView.animate(withDuration: self.animationDuration, animations: {
    sender.transform = CGAffineTransform(rotationAngle: -0.999 * .pi)
}) { (_) in
    UIView.animate(withDuration: self.animationDuration) {
        sender.transform = CGAffineTransform.identity
    }
}
```

### [Auto Layout Remake with Animation Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Auto_Layout/Auto_Layout_Remake_Animation.playground)

<a href="url"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/Auto_Layout_Remake_Animation.gif" align="center" height=25% width=25% ></a>
```swift
private var squareOriginConstraints: [NSLayoutConstraint] = []

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
```
