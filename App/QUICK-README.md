# The Self App - IOS
This is a 1 min QUICK-README to get started with the project in Xcode. 

*You're advised to read the full developer **Notes** documentation in the same directory as this file when you get the chance.*


## Get Started
- Use the xcworkspace file
- Remember to install the current pod versions.


## Structure
**The project is split up as follows (*MMCVVC*+PEA):**

-  **Models** - Data models.
-  **Model Controllers** - Controllers and implementers of the data models.
-  **Views** - Component views
-  **View Controllers** - Controllers of component views.
-  **Protocols** - Protocols.
-  **Extensions** - Extensions of framework classes.
-  **Assets** - Static assets the project relies on (inc. content and configurations).

Each of these are further split up into *Generic Reusables* and *Final Classes*, more information about this is in the documentation notes.



## Swift 4.2
- Downgrade *MarqueeLabel*, *NotificationBannerSwift*, *SwiftyJSON* targets to Swift 4.2 in their *Build Settings*, *under Swift Compiler Version*. This seems to work with their current versions.
- The project uses some Swift 5 features, they'll need to be manually revised.
