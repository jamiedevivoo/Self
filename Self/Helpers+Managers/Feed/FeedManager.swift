import UIKit

class FeedManager {
    
    static func generateMessage(forAccount account: Account) -> FeedMessage {
        let greeting = FeedManager.generateGreeting()
        let name = account.user.name ?? "Stranger"
        let messageContent = matchCustomMessage(forAccount: account)
        return FeedMessage(messageType: .time, greeting: greeting, name: name, messageText: messageContent.text, actions: messageContent.responses)
    }
    
    static private func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 00...03:
            return "zzz"
        case 04...06:
            return "Early Morning!"
        case 07...10:
            return "Good Morning,"
        case 10...12:
            return "It's Lunchtime!"
        case 12...17:
            return "Good Afternoon,"
        case 17...22:
            return "Good Evening,"
        case 22...24:
            return "Good Night,"
        default:
            return "Welcome"
        }
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
            // if no mood created
                messageText = "You're amazing! Welcome to Self! Let's log your first mood."
                messageResponses = [FeedMessageResponse(title: "+ Log my first mood", action: "N/A", sentimentTrend: .neutral)]
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
