struct Sentiment {
    enum Origin: String, CaseIterable {
        case messgae_response, unknown
        
        var key: String { return rawValue }
        
        static func matchCase(string: String) -> Sentiment.Origin {
            switch string {
            case self.messgae_response.rawValue:    return .messgae_response
            default:                                return .unknown
            }
        }
    }
    
    enum Trend: String, CaseIterable {
        case positive, negative, neutral
        
        var key: String { return rawValue }
        
        static func matchCase(string: String) -> Sentiment.Trend {
            switch string {
            case self.positive.rawValue:    return .positive
            case self.negative.rawValue:    return .negative
            default:                        return .neutral
            }
        }
    }
}
