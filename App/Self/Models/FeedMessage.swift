extension Feed {
    struct Message {
        var type: FeedMessageType
        var text: String
        var tags: [Tag]? = []
        
        enum FeedMessageType {
            case tutorial, account, dailyAction, insight, fun, mood, other
        }
    }
}
