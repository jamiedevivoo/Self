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
        if account.flags.tutorialIsActive == true {
            
            /// Priority 0.1 - Logic for creating the first mood
            if moods.count >= 1 {
                return (
                "You're amazing! Welcome to Self! Let's log your first mood.",
                [FeedMessageResponse(title: "+ Log my first mood", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.2 - Logic for responding to first message
            if moods.count >= 1 { //ERROR: Needs condition
                return (
                "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it now!",
                [FeedMessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
                FeedMessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
            
            
        }
        
        /// Priority 0 - Logic for when user is in tutorial mode
        if (account.flags.tutorialIsActive == true) {
            
        }
        
        
//        account_complete // Signed up with email and password
//        account_validated // Email confirmed
//        tutorial_active // Tutorial not complete
        
        return (message: "tu", responses: [])
    }
    
    
    static private func generageMessageText() -> String {
        return "Did you know Mondays are your happiest days? Let’s rock today!"
    }
    
    static private func matchCustomMessage(forAccount account: Account) -> (text: String, responses: [FeedMessageResponse]) {
        let account: Account = account
        let moodManager: MoodManager = MoodManager()
        let insightManager: InsightManager = InsightManager()
        let actionManager: ActionManager = ActionManager()
        
        var messageText: String, messageResponses: [FeedMessageResponse]
        
        // BEGIN LOGIC
        if  account.flags.tutorialIsActive == true,
            account.flags.accountIsComplete == false
        {
            //            // else if mood is created
            //                // if no message interaction yet
            //                text = "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it now!"
            //                responses = [
            //                    MessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
            //                    MessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)
            //                ]
            //                // else if mood interaction exists
            //                text = "If you're ever feeling really down and need some help, look for the sos button. Try it now."
            //                responses = [
            //                    MessageResponse(title: "🆘", action: "N/A", sentimentTrend: .negative),
            //                ]
            //        }
        } else {
            messageText = "Did you know Mondays are your happiest days? Let’s rock today!"
            messageResponses = [
                FeedMessageResponse(title: "💪", action: "NA", sentimentTrend: .positive),
                FeedMessageResponse(title: "😔", action: "NA", sentimentTrend: .negative),
                FeedMessageResponse(title: "🆘", action: "NA", sentimentTrend: .negative)
            ]
        }
        
        return (messageText, messageResponses)
        
    }
    
    //    // If the user is in tutorial mode and hasn't responded to a button yet
    //    text = "Great work, let's get you started with some to-do's."
    //    responses = [
    //        MessageResponse(title: "🎉", action: "N/A", sentimentTrend: .positive),
    //        MessageResponse(title: "🤔", action: "N/A", sentimentTrend: .neutral)
    //    ]
    //
    //    text = "You're amazing! Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better"
    //    responses = [
    //        MessageResponse(title: "", action: "N/A", sentimentTrend: .neutral),
    //        MessageResponse(title: "", action: "N/A", sentimentTrend: .neutral)
    //    ]
    //
    //
    //
    //
}

// Feed Action Methods
extension FeedManager {

}
