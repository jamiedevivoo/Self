import UIKit

extension Sentiment {
    struct Log {
        var uid: String?
        var context: String
        var origin: Sentiment.Origin
        var sentiment: Sentiment.Trend
        var timestamp: Date
        var title: String
    }
}

extension Sentiment.Log {

    init(_ sentimentDictionary: [String: Any]) {
        if let uid: String = sentimentDictionary["uid"] as? String {
            self.uid = uid
        }
        self.title = sentimentDictionary["title"] as! String
        self.timestamp = sentimentDictionary["timestamp"] as! Date
        self.title = sentimentDictionary["title"] as! String
        self.context = sentimentDictionary["context"] as! String
        self.origin = Sentiment.Origin.matchCase(string: sentimentDictionary["origin"] as? String ?? "")
        self.sentiment = Sentiment.Trend.matchCase(string: sentimentDictionary["sentiment"] as? String ?? "")
    }

    var dictionary: [String: Any] {
        return [
            "sentimentRef": self.context,
            "context": self.context,
            "origin": self.origin.rawValue,
            "sentiment": self.sentiment.rawValue as Any,
            "timestamp": self.timestamp as Date,
            "title": self.title as String
        ]
    }
}

