import UIKit

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

let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.json"

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

// if in class: fetchItunesDataWithResults { [weak self] (data, err) in

fetchItunesData { (albumData, err) in
    if let err = err {
        // TODO add handler here to respond to bad data call
        print("Failed to return data: ", err)
        return
    }
    
    guard let results = albumData?.feed.results else { return }
    
    results.forEach({ (album) in
        if let name = album.name {
            print(name)
        }
    })
}
