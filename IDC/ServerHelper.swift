import Foundation

let clientId = "MjE4OTA4MjJ8MTYyMDcwMDU3OS44MTIxNTk4"
let baseURL = "https://api.seatgeek.com/"

typealias Completion = (_ response: Any, _ status: Bool) -> Void

struct ServerHelper {
    static var shared = ServerHelper()
    private init() {}

    var request: URLSessionDataTask!
    
    mutating func getEventsForSearchQuery(_ query: String, completion: @escaping Completion) {
        if request != nil {
            request.suspend()
        }
        let urlString = String(format:  baseURL + "2/events?client_id=\(clientId)&q=%@", query)
        request = createRequest(urlString: urlString) { (data, status) in
            if let respData = data as? Data {
                do {
                    let jsonString = try JSONSerialization.jsonObject(with: respData, options: .allowFragments)
                    let eventData = try JSONSerialization.data(withJSONObject: (jsonString as? [String: Any])?["events"] ?? [
                    ], options: .fragmentsAllowed)
                    let events = try JSONDecoder().decode([Event].self, from: eventData)
                    completion(events, status)
                } catch {
                    completion("", status)
                }
            }
            completion("", status)
        }
        request.resume()
    }
    
    
    private func createRequest(urlString: String, completion: @escaping Completion) -> URLSessionDataTask {
  
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = ["content-type": "application/json", "accept": "application/json"]
        request.httpMethod = "GET"
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print(error ?? "")
                completion("", false)
            } else {
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let jsonString = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            print(jsonString)
                        } catch { }
                        completion(data ?? "", true)
                        break
                    case 400:
                        completion(response!, false)
                        break
                    default:
                        completion(data ?? "", false)
                        break
                    }
                }
                
            }
        }
    }
    
}
