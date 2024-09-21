import ArgumentParser
import Foundation
import FoundationNetworking
import CoreFoundation
import Swift

@main
struct SpoofyTerminal: ParsableCommand {

    private static let cacheFile = "~/.cache/spotify_cache.json"

    @Argument
    var action: String? = nil

    mutating func run() throws {
        print("running SpoofyTerminal")
        let actionType = SpotifyAction(rawValue: action ?? "") ?? .help
        actionType.action()
    }
}

/// This is the struct that will hold cached data 
struct SpotifyInformation: Codable {
    /// The username of logged in user
    let username: String
    /// The password of the logged in user
    let password: String
    /// The users authentication token
    let token: String

    init(username: String, password: String, token: String) {
        self.username = username
        self.password = password
        self.token = token
    }
}

enum SpotifyAction: String, CaseIterable {
    case play, pause, next, prev, help, authenticate
    
    func action() {
        switch self {
            case .play: Self.play()
            case .pause: Self.pause()
            case .next: Self.next()
            case .prev: Self.prev() 
            case .authenticate: Self.authenticate()
            case .help: Self.help()
        }
    }

    private func helpText() {
         switch self {
            case .play: print("play")
            case .pause: print("pause")
            case .next: print("next")
            case .prev: print("prev")
            case .authenticate: print("authenticate")
            case .help: print("help")
        }
    }

    private static func play() {}

    private static func pause() {}

    private static func next() {}

    private static func prev() {
    }

    @discardableResult
    private static func authenticate() -> Data {
        if let data = try? Data(contentsOf: URL(string: "~/.cache/spotify_cache.json")!) {
            return data
        } else {
            Task {
               let data = await NetworkRequestType.get.makeRequest(with: URLRequest(url: URL(string: "")!))
               return data
            }
        }
    }

    private static func help() {
       print("SpoofyTerminal help")
       for action in SpotifyAction.allCases {
           print(action.rawValue)
           action.helpText()
       }
    }
}

enum NetworkRequestType: String {
    case get = "GET", post = "POST"

    func makeRequest(with request: URLRequest) async {
        _ = await URLSession.shared.data(for: request)
    }

}
