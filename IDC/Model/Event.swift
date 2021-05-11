import Foundation

class Event: Codable {
    let id: Int?
    let title: String?
    let venue: Venue?
    let performers: [Performers]?
    let datetime: String?
    enum CodingKeys: String, CodingKey {
        case id, title, venue, performers
        case datetime = "datetime_local"
    }
}

class Venue: Codable {
    let displayLocation: String?
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}

class Performers: Codable {
    let image: String?
}
