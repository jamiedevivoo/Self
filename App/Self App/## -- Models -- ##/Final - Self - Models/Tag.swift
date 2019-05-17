import Firebase

struct Tag {
    // Universal States
    
    var uid: String?
    var tagRef: DocumentReference?
    
    var title: String
    var description: String?
    var category: Tag.TagCategory = .personal

    var origin: TagOrigin = .unknown
    var valenceInfluence: Double = 1
    var arousalInfluence: Double = 1
}

// MARK: - Convenience Iniitialiser
extension Tag {
    init(_ tagDictionary: [String: Any]) {
        self.title = (tagDictionary["title"] as! String)
        
        if let uid: String = tagDictionary["uid"] as? String, uid.count > 0 {
            self.uid = uid
        }
        
        if let description: String = tagDictionary["description"] as? String, description.count > 0 {
            self.description = description
        }
        
        if let tagRef: DocumentReference = tagDictionary["tagRef"] as? DocumentReference {
            self.tagRef = tagRef
        }
        
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
        var dictionary = [
            "title": title as Any,
            "origin": origin.rawValue as Any,
            "category": category.rawValue as Any,
            "valence_influence": valenceInfluence as Any,
            "arousal_influence": arousalInfluence as Any
        ]
        
        if let description = self.description, description.count > 0 {
            dictionary["description"] = description as Any
        }
        
        if let tagRef: DocumentReference = self.tagRef {
            dictionary["tag_ref"] = tagRef
        }
        
        return dictionary
    }
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
