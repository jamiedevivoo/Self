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
        forAccount accountManager: AccountManager,
        withMoods moods: [Mood.Log],
        withInsight insightss: [Insight],
        withActions actionLogs: [Sentiment.Log],
        withSentimentLogs sentimentLogs: [ActionManager.Log])
    -> (message: Feed.Status.Message, responses: [Feed.Status.Response]) {
        let account = accountManager.accountRef!
        
        /// Priority 0 - Logic for when user is in tutorial mode
        if account.flags.tutorialIsActive {
            
            /// Priority 0.1 - Catch users who haven't logged a mood
            guard !(moods.count < 1) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstMood"][0]["text"].stringValue, tags: []),
                 Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstMood"][0]["text"].stringValue, tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "✏️ Log my first mood", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral)])
            }
            
            /// Priority 0.2 - Catch users who haven't responded to a message
            guard (accountManager.checkMilestone("first_message_tapped") == true) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstMessageInteraction"][0]["text"].stringValue, tags: []),
                 Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstMessageInteraction"][0]["text"].stringValue, tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "🎉", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral),
                 Feed.Status.Response(title: "🤔", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral)])
            }
            
            /// Priority 0.3 - Catch users who haven't tapped SOS yet
            guard (accountManager.checkMilestone("first_sos_tap") == true) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstSOS"][0]["text"].stringValue, tags: []),
                 Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstSOS"][1]["text"].stringValue, tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "🆘", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral)])
            }

            /// Priority 0.4 - Catch users who haven't chosen a challenge yet
           guard !(actionLogs.count < 1) else {
                return (
                [Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstChallenge"][0]["text"].stringValue, tags: []),
                 Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["firstChallenge"][1]["text"].stringValue, tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "👍", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral),
                 Feed.Status.Response(title: "👎", action: #selector(FeedMessageChildViewController.logNewMood), sentimentTrend: .neutral)])
            }
            
            /// Priority 0.5 - Catch users who haven't completed their account yet
            guard account.flags.accountIsComplete else {
                return (
                [Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["completeAccount"][0]["text"].stringValue, tags: []),
                 Feed.Status.Message(type: .tutorial, text: StaticMessages.get["feed"]["tutorial"]["completeAccount"][1]["text"].stringValue, tags: [])
                ].randomElement()!,
                [Feed.Status.Response(title: "✓ Complete my account", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
            }
            
        }
        
        let randomNumber = Int.random(in: 0 ..< 10)
        
        /// Priority 1.0 - Urgent messages, updates and Account notifications
        ///
        
        /// 1.1 New unviewed Insight
        if randomNumber < 9 {
            guard (accountManager.checkMilestone("new_insight") == true) else {
                return (
                    [Feed.Status.Message(type: .insight, text: StaticMessages.get["feed"]["message"]["insightPrompt"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .insight, text: StaticMessages.get["feed"]["message"]["insightPrompt"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "💡", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
                }
        }
        
        /// Priority 2.0 - Abnormal behaviour (low mood, no recent moods, no recent actions)
        /// 2.1 Low mood
        if randomNumber < 8 {
            guard (accountManager.checkMilestone("low_mood") == true) else {
                return (
                    [Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["lowMood"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["lowMood"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "👍", sentimentTrend: .positive),
                     Feed.Status.Response(title: "👎", sentimentTrend: .negative)])
            }
        }

        /// Priority 3.0 - Outstanding events
        if randomNumber > 2 {
            
            // 3.1 Unlock today's Challenge!
            guard (accountManager.checkMilestone("dailyMoodComplete") == true) else {
                return (
                    [Feed.Status.Message(type: .mood, text: StaticMessages.get["feed"]["message"]["moodPrompt"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .mood, text: StaticMessages.get["feed"]["message"]["moodPrompt"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "+ Log a mood", action: #selector(FeedMessageChildViewController.), sentimentTrend: .neutral)])
            }
            
            // 3.2 Log a mood for today
            guard (accountManager.checkMilestone("dailyActionComplete") == true) else {
                return (
                    [Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["actionPrompt"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["actionPrompt"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "📦 Open todays challenge", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
            }
            
            // 3.2 New Highlight added
            guard (accountManager.checkMilestone("newHighlightAdded") == true) else {
                return (
                    [Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["highlightPrompt"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["highlightPrompt"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "🎉 View new highlight", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
            }
        }
        
        /// Priority 4.0 - Generic reminders
        if randomNumber > 5 {
            // 4.1 How is the daily challenge going?
            guard (accountManager.checkMilestone("dailyChallengeExistsButNotComplete") == true) else {
                return (
                    [Feed.Status.Message(type: .mood, text: StaticMessages.get["feed"]["message"]["challengeNeedsCompleting"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .mood, text: StaticMessages.get["feed"]["message"]["challengeNeedsCompleting"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "👍", sentimentTrend: .positive),
                     Feed.Status.Response(title: "👎", sentimentTrend: .negative)])
            }
            
            // 4.2 Mood logged but no wildcard question
            guard (accountManager.checkMilestone("moodLoggedButWithoutWildcard") == true) else {
                return (
                    [Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["moodWithoutWildcard"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["moodWithoutWildcard"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "+ Answer the question of the day", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
            }
            
            // 4.3 Mood reminders "Reflect on this mood"
            guard (accountManager.checkMilestone("reflectOnDailyMood") == true) else {
                return (
                    [Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["reflectOnHighlight"][0]["text"].stringValue, tags: []),
                     Feed.Status.Message(type: .dailyAction, text: StaticMessages.get["feed"]["message"]["reflectOnHighlight"][1]["text"].stringValue, tags: [])
                        ].randomElement()!,
                    [Feed.Status.Response(title: "+ Add reflection", action: #selector(FeedMessageChildViewController.comple), sentimentTrend: .neutral)])
            }
        }
        
        // Finally if all above priority guards pass, return a random message from a random group.
        return [
            
            // Facts about mental health
            [
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["fact"][0]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "💪", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🤘", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["fact"][1]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "🤘", sentimentTrend: .positive),
                  Feed.Status.Response(title: "💪", sentimentTrend: .positive)])
            ].randomElement()!,
            
            // Friendly comments
            [
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["friendly"][0]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "👌", sentimentTrend: .positive),
                  Feed.Status.Response(title: "😀", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["friendly"][1]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "😩", sentimentTrend: .positive),
                  Feed.Status.Response(title: "👌", sentimentTrend: .positive)])
            ].randomElement()!,
            
            // Messages of support
            [
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["support"][0]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "✓", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🛠", sentimentTrend: .positive)]),
                (Feed.Status.Message(type: .other, text: StaticMessages.get["feed"]["message"]["friendly"][1]["text"].stringValue, tags: []),
                 [Feed.Status.Response(title: "👨‍💻", sentimentTrend: .positive),
                  Feed.Status.Response(title: "🙃", sentimentTrend: .positive)])
            ].randomElement()!
            
        ].randomElement()!
    }
}

// Feed Action Methods
extension FeedManager {
    
}
