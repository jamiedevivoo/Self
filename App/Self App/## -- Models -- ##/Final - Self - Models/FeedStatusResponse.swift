import UIKit

extension Feed.Status {
    struct Response {
        let title: String
        let action: Selector
        let sentimentTrend: Sentiment.Trend
        
        init(title: String, action: Selector? = #selector(FeedMessageChildViewController.messageResponse), sentimentTrend: Sentiment.Trend) {
            self.title = title
            self.action = action!
            self.sentimentTrend = sentimentTrend
        }
    }

}
