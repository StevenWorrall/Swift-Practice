# Swift Practice
This is a Git repository that I use to store some playgrounds where I practice Swift functionality.

## [Auto Layout Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/)
Some exmaples ranging from basic view placement all the way to remaking constraints and updating them based on user interaction within the view. Click on the pictures to see their source code or [here](https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/) to see a more detailed Readme.
<p align="center">
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/BasicAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAutoLayout.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/BasicAnimationAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicAnimationAutoLayout.gif" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/AutoLayout/RemakeAnimationAutoLayout.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/RemakeAnimationAutoLayout.gif" height=400px width=auto ></a>
</p>


## [Table View Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/)
Some examples ranging from a basic Table View all the way to a Table View implementing a custom cell with Auto Layout and Async image loading. Click on the pictures to see their source code or [here](https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/) to see a more detailed Readme.
<p align="center">
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/BasicTableView.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicTableView.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/TextBasedWithNetwork.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/TextBasedWithNetwork.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/TextBasedWithImagePopover.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/TextBasedWithImagePopover.gif" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift-Practice/tree/master/TableView/ImageBasedWithNetworking.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/ImageBasedWithNetworking.gif" height=400px width=auto ></a>
</p>


## [Collection View Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/CollectionView/)
Some examples ranging from a basic Collection View all the way to a Collection View implementing a custom cell with Auto Layout and Async image loading and pagination. Click on the pictures to see their source code or [here](https://github.com/StevenWorrall/Swift-Practice/tree/master/CollectionView/) to see a more detailed Readme.
<p align="center">
	<a href="https://github.com/StevenWorrall/Swift_Practice/tree/master/CollectionView/BasicCollectonView.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/BasicCollectionView.png" height=400px width=auto ></a>
	<a href="https://github.com/StevenWorrall/Swift_Practice/tree/master/CollectionView/ImageBasedWithNetwork.playground"><img src="https://github.com/StevenWorrall/Swift-Practice/blob/master/Pictures/ImageBasedWithNetwork.png" height=400px width=auto ></a>
</p>

## [Networking Practice](https://github.com/StevenWorrall/Swift-Practice/tree/master/Networking/)
Practicing networking by starting with basic networking calls and slowly introducing more complex additions such as Result types and Generics
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




## [Utilities](https://github.com/StevenWorrall/Swift-Practice/tree/master/Networking/)
Some extensions and helpers I've found to be extremely helpful while developing. All credit given, where necessary, in the playground file.
#### [Adding Images with a Cache (Table Views)](https://github.com/StevenWorrall/Swift_Practice/tree/master/Utilities/AddingImagesWithCache.playground)
<details>
  <summary>Expand for code block:</summary>
  
```swift
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
```
</details>




