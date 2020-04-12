# Swift Practice
This is a Git repository that I use to store some playgrounds where I practice Swift functionality.

## [Auto Layout Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/)

<a href="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAutoLayout.png" height=400px width=auto ></a>
<a href="url"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAnimationAutoLayout.gif" height=400px width=auto ></a>
<a href="url"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/RemakeAnimationAutoLayout.gif" height=400px width=auto ></a>


## [Networking Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Networking/)

```swift
func fetchItunesData(completion: @escaping (FeedResponse?, Error?) -> ()) {
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, resp, error) in
        if let err = error {
            completion(nil, err)
            return
        }
        do {
            let albumData = try JSONDecoder().decode(FeedResponse.self, from: data!)
            completion(albumData, nil)
        } catch let jsonError {
            completion(nil, jsonError)
        }
    }.resume()
}
```