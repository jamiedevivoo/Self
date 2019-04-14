import UIKit

class MessageManager {
    
    static func generateMessage(forAccount account: Account) -> Message {
        let greeting = MessageManager.generateGreeting()
        let name = account.user.name ?? "Stranger"
        let messageText = MessageManager.generageMessageText()
        let actions = MessageManager.generateMessageResponses()
        return Message(messageType: .time, greeting: greeting, name: name, messageText: messageText, actions: actions)
    }
    
    static private func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 00...03:
            return "zzz"
        case 04...06:
            return "Early Morning"
        case 07...10:
            return "Good Morning"
        case 10...12:
            return "It's Lunchtime"
        case 12...17:
            return "Good Afternoon"
        case 17...22:
            return "Good Evening"
        case 22...24:
            return "Good Night"
        default:
            return "Welcome"
        }
    }
    
    static private func generageMessageText() -> String {
        return "Did you know Mondays are your happiest days? Let’s rock today!"
    }
    
    static private func generateMessageResponses() -> [MessageResponse] {
        var messageResponses: [MessageResponse] = []
        
        let message1 = MessageResponse(title: "💪", action: "NA", sentimentTrend: .positive)
        let message2 = MessageResponse(title: "😔", action: "NA", sentimentTrend: .negative)
        let message3 = MessageResponse(title: "🆘", action: "NA", sentimentTrend: .negative)

        messageResponses = [message1,message2,message3]
        
        return messageResponses
    }
}
