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
    func generateGreeting() -> String {
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
        withMoods moods: [Mood.Log],
        withInsight insightss: [Insight],
        withActions actionLogs: [Sentiment.Log],
        withSentimentLogs sentimentLogs: [ActionManager.Log])
    -> (message: Feed.Status.Message, responses: [Feed.Status.Response]) {
        
        /// Priority 0 - Logic for when user is in tutorial mode
        if account.flags.tutorialIsActive {
            
            /// Priority 0.1 - Catch users who haven't logged a mood
            guard !(moods.count < 1) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: "Welcome to Self! You're amazing! Let's log your first mood.",tags: []),
                 Feed.Status.Message(type: .tutorial, text: "You're amazing! Welcome to Self! How are you feeling?",tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "✏️ Log my first mood", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.2 - Catch users who haven't responded to a message
            guard !(sentimentLogs.count < 2) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: "Great work! This screen will reguarly update with the latest advice and messages, You can use the emoji's below to respond to each message and help me get to know you better. Try it now!",tags: []),
                 Feed.Status.Message(type: .tutorial, text: "Awesome! I'll keep hold of that for you. Every day I'll help you reflect on yourself with advice and messages like this. You can use the emoji's below to respond to each message and help me get to know you better. Try it",tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "🎉", action: "N/A", sentimentTrend: .neutral),
                 Feed.Status.Response(title: "🤔", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.3 - Catch users who haven't tapped SOS yet
            guard !(sentimentLogs.count < 3) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: "No one feels 100% all of the time, for those times when you're feeling down, look out for the SOS button to find useful crisis sources and advice. It's also always visible in the sidebar. Try tapping it now.",tags: []),
                 Feed.Status.Message(type: .tutorial, text: "If you're ever feeling really down and need some help, look out for the SOS button. You can also find it in the sidebar. Tap it now to see what's available.",tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "🆘", action: "N/A", sentimentTrend: .neutral)])
            }

            /// Priority 0.4 - Catch users who haven't chosen a challenge yet
           guard !(actionLogs.count < 1) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: "Ready for your first challenge? Let's go!",tags: []),
                 Feed.Status.Message(type: .tutorial, text: "Every day you'll get a challenge to complete, let's see what today's is!",tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "👍", action: "N/A", sentimentTrend: .neutral),
                 Feed.Status.Response(title: "👎", action: "N/A", sentimentTrend: .neutral)])
            }
            
            /// Priority 0.5 - Catch users who haven't completed their account yet
            guard account.flags.accountIsComplete else {
                return (
                [Feed.Status.Message(type: .account, text: "Self is all about you. As the app learns from you and get's to know you you'll unlock insights, highlights and trophies. When you're ready to exlore more of Self, finish creating your account below.",tags: []),
                 Feed.Status.Message(type: .tutorial, text: "Wow, you've already covered the basics! But there's still so much more. To unlock highlights, insights and trophies, finish creating your account below and continue using the app to track and improve your wellbeing.",tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "✓ Complete my account", action: "N/A", sentimentTrend: .neutral)])
            }
            
        }
        
        /// Priority 1.0 - Urgent messages, updates and Account notifications
            // 1.1 New unviewed Insight
        
        /// Priority 2.0 - Abnormal behaviour (low mood, no recent moods, no recent actions)
            // 2.1 Low mood

        /// Priority 3.0 - Outstanding events
            // 3.1 Unlock today's Challenge!
            // 3.2 Log a mood for today

        /// Priority 4.0 - Generic reminders
            // 4.1 How is the daily challenge going?
            // 4.2 Mood logged but no wildcard question
            // 4.3 Mood reminders "Reflect on this mood"
        
        
        // Finally if all above priority guards pass, return a random message from a random group.
        return [
            
            // Facts about mental health
            [
                (Feed.Status.Message(type: .other, text: "Here's a random fact about wellbeing",tags: []),
                 [Feed.Status.Response(title: "💪", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🤘", action: "N/A", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: "Here's another random fact about wellbeing",tags: []),
                 [Feed.Status.Response(title: "🤘", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "💪", action: "N/A", sentimentTrend: .positive)])
            ].randomElement()!,
            
            // Friendly comments
            [
                (Feed.Status.Message(type: .other, text: "Here's a random message to motivate you",tags: []),
                 [Feed.Status.Response(title: "👌", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "😀", action: "N/A", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: "Here's another random message to motivate you",tags: []),
                 [Feed.Status.Response(title: "😩", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "👌", action: "N/A", sentimentTrend: .positive)])
            ].randomElement()!,
            
            // Messages of support
            [
                (Feed.Status.Message(type: .other, text: "Here's a supportive message to enourage positive activity.",tags: []),
                 [Feed.Status.Response(title: "✓", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🛠", action: "N/A", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: "Here's a slightly longer supportive message to enourage positive activity and test the constraints.",tags: []),
                 [Feed.Status.Response(title: "👨‍💻", action: "N/A", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🙃", action: "N/A", sentimentTrend: .positive)])
            ].randomElement()!
            
        ].randomElement()!
    }
}

// Feed Action Methods
extension FeedManager {
    
}
