import Firebase

struct Tag {
    // Universal States
    var title: String
    var description: String?
    var category: Tag.TagCategory = .personal

    var origin: TagOrigin = .unknown
    var valenceInfluence: Double?
    var arousalInfluence: Double?
}

// MARK: - Convenience Iniitialiser
extension Tag {
    init(_ tagDictionary: [String: Any]) {
        self.title              = (tagDictionary["title"] as! String)
        self.description        = (tagDictionary["description"] as! String)
        self.valenceInfluence   = (tagDictionary["valence_influene"] as? Double ?? valenceInfluence)
        self.arousalInfluence   = (tagDictionary["arousal_influence"] as? Double ?? arousalInfluence)
        self.origin             = TagOrigin.matchCase(string: tagDictionary["origin"] as? String ?? "")
        self.category           = TagCategory.matchCase(string: tagDictionary["category"] as? String ?? "")
    }
}

// MARK: - Outputting
//// values as a dictionary (e.g. for Firebase)
extension Tag: DictionaryConvertable {
    var dictionary: [String: Any] {
        return [
            "title": title as Any,
            "description": description as Any,
            "origin": origin.rawValue as Any,
            "category": category.rawValue as Any,
            "valence_influence": valenceInfluence as Any,
            "arousal_influence": arousalInfluence as Any
        ]
    }
    var logTagDictionary: [String: Any] {
        return [
            "title": title as Any,
            "description": description as Any,
            "category": category.rawValue as Any
        ]
    }
    var actionTagDictionary: [String: Any] {
        return [
            "title": title as Any,
            "description": description as Any,
            "category": category.rawValue as Any
        ]
    }

//    var dictionary: [String: Any] {
//        return [
//            "tagRef":       tagRef! as DocumentReference,
//            "title":        title as Any,
//            "description":  description as Any,
//            "category":     category.rawValue as Any
//        ]
//    }
}

// MARK: - Types
extension Tag {
    
    enum TagOrigin: String, CaseIterable {
        case mood, action, response, insight, community, unknown
        
        var key: String { return rawValue }
        
        static func matchCase(string: String) -> TagOrigin {
            switch string {
            case self.mood.rawValue:        return .mood
            case self.action.rawValue:      return .action
            case self.response.rawValue:    return .response
            case self.insight.rawValue:     return .insight
            case self.community.rawValue:   return .community
            default:                        return .unknown
            }
        }
    }
    
    enum TagCategory: String, CaseIterable {
        case fiveWays, type, charka, auto, personal
        
        var key: String { return rawValue }
        
        var title: String {
            switch self {
            case .fiveWays:    return "Five Ways"
            case .type:        return "Action Type"
            case .charka:      return "Charka"
            case .auto:        return "Automatic Tag"
            default:           return "Personal"
            }
        }
        
        static func matchCase(string: String) -> TagCategory {
            switch string {
            case self.fiveWays.rawValue:   return .fiveWays
            case self.type.rawValue:        return .type
            case self.charka.rawValue:      return .charka
            case self.auto.rawValue:        return .auto
            default:                        return .personal
            }
        }
    }
}
