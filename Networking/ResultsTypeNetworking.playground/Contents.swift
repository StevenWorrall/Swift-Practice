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

func fetchItunesDataWithResults(completion: @escaping (Result<FeedResponse, Error>) -> ()) {
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
        if let err = err {
            completion(.failure(err))
            return
        }
        
        do {
            let dataResponse = try JSONDecoder().decode(FeedResponse.self, from: data!)
            completion(.success(dataResponse))
        } catch let jsonError {
            completion(.failure(jsonError))
        }
        
    }.resume()
}

// if in class: fetchItunesDataWithResults { [weak self] (data, err) in

fetchItunesDataWithResults { (result) in
    switch result {
    case .success(let data):
        guard let resultData = data.feed.results else { return }
        
        resultData.forEach({ (album) in
            if let name = album.name {
                print(name)
            }
        })
    case .failure(let err):
        print(err)
        return
    }
}
