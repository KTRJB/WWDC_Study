## APIDefinition
```swift
protocol APIDefinition {
    
    var baseURL: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
    
}

extension APIDefinition {
    
    var path: String? {
        nil
    }
    var headers: [String: String]? {
        [:]
    }
    var query: [String: String]? {
        nil
    }
    var body: Data? {
        nil
    }
    var url: URL? {
        var component = URLComponents(string: self.baseURL + ("/" + (self.path ?? "")))
        component?.queryItems = query?.reduce([URLQueryItem]()) { $0 + [URLQueryItem(name: $1.key, value: $1.value)] }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.httpBody = body
        self.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
    
}
```

## HTTPRequestable
```swift
protocol HTTPRequestable {
    
    func execute(definitaion: APIDefinition, completion: @escaping (Result<Data, Error>) -> ())
    
}

extension HTTPRequestable {
    
    func execute(definitaion: APIDefinition, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let request = definitaion.urlRequest else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(NetworkError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if !(200...300 ~= response.statusCode) {
                completion(.failure(NetworkError.response(response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
}

enum NetworkError: Error {

    case invalidRequest
    case request
    case response(Int)
    case invalidData
    
}
```

# Protocol을 사용한 모델
```swift
// 다중상속 후 오버라이딩
protocol UnsplashReuqest: APIDefinition, HTTPRequestable { }

extension UnsplashReuqest {

    var baseURL: String {
        EndPoint.base
    }
    var path: String? {
        nil
    }
    var query: [String : Any]? {
        nil
    }
    var method: HTTPMethod {
        .get
    }
    var headers: [String: String]? {
        CommonHeader.headers()
    }
    var body: Data? {
        nil
    }
    
}

extension UnsplashReuqest {

    func execute(completion: @escaping (Result<Data, Error>) -> Void) {
        execute(definitaion: self, completion: completion)
    }
    
}

// 구조체로 구현
struct TopicRequest: UnsplashReuqest {
    
    var path: String? = "topics"
    var query: [String : String]? = ["per_page": "19"]
    
}

// 실제 호출
let request = TopicRequest()
request.execute { (result: Result<Data, Error>) in
    switch result {
    case .success(let data):
        self.topics = try? JSONDecoder().decode([Topic].self, from: data)
    case .failure(let error):
        print(error.localizedDescription)
    }
            
    DispatchQueue.main.async {
        self.navigationView.customTabBarView.configureMeunList(self.topics?.map { $0.title })
    }
}
```
