import Firebase

struct Tag {
    // Universal States
    var title: String
    var description: String
    var category: Tag.TagCategory = .personal
    
    // Log View
    var uid: String? = nil

    // Log state only
    var tagRef: DocumentReference? = nil
    
    // Creation state Only
    var origin: TagOrigin = .unknown
    var valenceInfluence: Double = 0
    var arousalInfluence: Double = 0
}

// MARK: - Convenience Iniitialiser
extension Tag {
    init(_ tagDictionary: [String:Any]) {
        self.uid                = (tagDictionary["uid"] as? String ?? nil)
        self.tagRef             = (tagDictionary["tag_ref"] as? DocumentReference ?? nil)
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
            "uid":                  uid as Any,
            "tag_ref":              tagRef as Any,
            "title":                title as Any,
            "description":          description as Any,
            "origin":               origin.rawValue as Any,
            "category":             category.rawValue as Any,
            "valence_influence":    valenceInfluence as Any,
            "arousal_influence":    arousalInfluence as Any
        ]
    }
    var logTagDictionary: [String: Any] {
        return [
            "tag_ref":      tagRef as! DocumentReference,
            "title":        title as Any,
            "description":  description as Any,
            "category":     category.rawValue as Any
        ]
    }
    var actionTagDictionary: [String: Any] {
        return [
            "tag_ref":      tagRef as! DocumentReference,
            "title":        title as Any,
            "description":  description as Any,
            "category":     category.rawValue as Any
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
        
        static func matchCase(string:String) -> TagOrigin {
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
        case five_ways, type, charka, personal
        
        var key: String { return rawValue }
        
        var title: String {
            switch self {
                case .five_ways:   return "Five Ways"
                case .type:        return "Action Type"
                case .charka:        return "Charka"
                default:               return "Personal"
            }
        }

        
        static func matchCase(string:String) -> TagCategory {
            switch string {
                case self.five_ways.rawValue:   return .five_ways
                case self.type.rawValue:        return .type
                case self.charka.rawValue:   return .charka
                default:                        return .personal
            }
        }
    }
}
