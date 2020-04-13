# Swift Practice
This is a Git repository that I use to store some playgrounds where I practice Swift functionality.

## [Auto Layout Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/)
<p align="center">
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/BasicAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAutoLayout.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/BasicAnimationAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAnimationAutoLayout.gif" margin-left=20px margin-right=20px height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/RemakeAnimationAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/RemakeAnimationAutoLayout.gif" height=400px width=auto ></a>
</p>


## [Table View Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/)
<p align="center">
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/BasicTableView.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicTableView.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/TextBasedWithNetwork.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/TextBasedWithNetwork.png" margin-left=20px margin-right=20px height=400px width=auto ></a>
</p>

## [Networking Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Networking/)

#### [Basic Networking](https://github.com/StevenWorrall/Swift_Practice/tree/master/Networking/BasicNetworking.playground)
<details>
  <summary>Expand for code block:</summary>
  
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
</details>

#### [Networking with Results](https://github.com/StevenWorrall/Swift_Practice/tree/master/Networking/ResultsTypeNetworking.playground)
<details>
  <summary>Expand for code block:</summary>
  
```swift
func fetchItunesDataWithResults(completion: @escaping (Result<FeedResponse, Error>) -> ()) {
	URLSession.shared.dataTask(with: url) { (data, resp, err) in
        if let err = err {
            completion(.failure(err))
            return
        }
    ...

fetchItunesDataWithResults { (result) in
    switch result {
    case .success(let data):
        guard let resultData = data.feed.results else { return }
        
        resultData.forEach({ (album) in
            if let name = album.name {
                print(name)
            }
        })
    ...
}
```
</details>

#### [Networking with Generics and Results](https://github.com/StevenWorrall/Swift_Practice/tree/master/Networking/GenericsNetworking.playground)
<details>
  <summary>Expand for code block:</summary>

```swift
public func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping ((Result<T, Error>) -> () )) {
	...
    do {
       	let dataResponse = try JSONDecoder().decode(T.self, from: data)
        completion(.success(dataResponse))
    } catch let jsonError {
        completion(.failure(jsonError))
    }
}

fetchGenericData(urlString: urlString) { (result: Result<FeedResponse, Error>) in
    ...
```
</details>

