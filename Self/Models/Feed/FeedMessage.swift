struct FeedMessage {
    var messageType: FeedMessageType
    var greeting: String
    var name: String
    var messageText: String
    var actions: [FeedMessageResponse]
    
    enum FeedMessageType {
        case time, insight, mood, urgent, other
    }
}
