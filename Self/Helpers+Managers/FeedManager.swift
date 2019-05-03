import UIKit

final class FeedManager {
    static fileprivate var sharedInstance: FeedManager?
    private init() {}
}
    
// MARK: Access Methods for Managing shared Instance
extension FeedManager {
    static func shared() -> FeedManager {
        guard let sharedInstance = sharedInstance else { return FeedManager() }
        return sharedInstance
    }
    
    static func destroy() {
        sharedInstance = nil
    }
}






// Feed Message - Header and Time - Methods
extension FeedManager {
    private func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 00...03: return "zzz"
        case 04...06: return "Early Morning!"
        case 07...10: return "Good Morning,"
        case 10...12: return "It's Lunchtime!"
        case 12...17: return "Good Afternoon,"
        case 17...22: return "Good Evening,"
        case 22...24: return "Good Night,"
        default:      return "Welcome"
        }
    }
}

// Feed Message - Contextual Message - Methods
extension FeedManager {
    
    func generateMessage(
        forAccount account: Account,
        withHighlights highlights: [Highlight],
        withMoods moods: [MoodLog],
        withInsight insightss: [Insight],
        withActions actionLogs: [ActionLog])
    -> (message: String, responses: [FeedMessageResponse]) {
        
        /// Priority 0 - Logic for when user is in tutorial mode
        if account.flags.tutorialIsActive {
            
            /// Priority 0.1 - Logic for creating the first mood
            if moods.count >= 1 {
                return (
                ["You're amazing! Welcome to Self! How are you feeling?",
                 "Welcome to Self! You're amazing! Let's log your first mood."
                ].randomElement()!,
                [FeedMessageResponse(title: "+ Log my first mood", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.2 - Logic for responding to first message
            if moods.count >= 1 { //ERROR: Needs condition
                return (
                ["Great work! This screen will reguarly update with the latest advice and messages, You can use the emoji's below to respond to each message and help me get to know you better. Try it now!",
                 "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it"
                ].randomElement()!,
                [FeedMessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
                 FeedMessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.3 - Logic for explaining SOS
            if moods.count >= 1 { //ERROR: Needs condition
                return (
                ["No one feels 100% all of the time, for those times when you're feeling down, look out for the SOS button for useful sources and advice. It's also always visible in the sidebar. Try tapping it now.",
                 "If you're ever feeling really down and need some help, look out for the SOS button. You can also find it in the sidebar. Tap it now to see what's available."
                ].randomElement()!,
                [FeedMessageResponse(title: "🆘", action: "N/A", sentimentTrend: .negative)])
            }

            /// Priority 0.4 - Logic for introducing challenges
            if moods.count >= 1 { //ERROR: Needs condition
                return (
                ["Ready for your first challenge?",
                 "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it now!"
                ].randomElement()!,
                [FeedMessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
                 FeedMessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.5 - Logic for requesting the user to complete their account
            if moods.count >= 1 { //ERROR: Needs condition
                return (
                ["Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it now!",
                 "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it now!"
                ].randomElement()!,
                [FeedMessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
                 FeedMessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
        } else {
        
            /// Priority 1 - Logic for when user is in tutorial mode
            if account.flags.tutorialIsActive {
                return(
                ["Did you know Mondays are your happiest days? Let’s rock today!",
                 "Did you know Mondays are your happiest days? Let’s rock today!"
                ].randomElement()!,
                [FeedMessageResponse(title: "💪", action: "NA", sentimentTrend: .positive),
                 FeedMessageResponse(title: "😔", action: "NA", sentimentTrend: .negative)])
            }
        
            /// Priority 1 - Logic for when user is in tutorial mode
            if account.flags.tutorialIsActive {
                
            }
        
        
        
            // Unlock today's Challenge!
            // How is the daily challenge going?
            // Low mood
            // How are you today
            // Mood logged but no wildcard question
            // New unviewed Insight
            // Mood reminders
            
            // fun Facts
            
            // Day Commentary
            
            
            
            
            
            
            
            // + Automatically add SOS if mood is low
            
        
        
        
        
        
        
        
        }
    }
}

// Feed Action Methods
extension FeedManager {

}
