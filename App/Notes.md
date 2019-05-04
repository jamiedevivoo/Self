# The Self App - IOS

Some documentation and ongoing notes by the author during the development of this project.


**[Methodology](#programming-design--methodology)**
- **M-MC-VC-V**
-  - Models

## Programming Design + Methodology
This isn't neccesarily "the correct" methodology or even a real methodology, but it'll help explain how this app has been developed and how the project is strucutred.

### "M-MC-VC-V"

#### - Models (M)
**The Data** /
A Model is an object containing multiple types of data that, when combined, describe something more significant.

**- Key points**
- The Model is absolute, it doesn't know or care about the context around itself (such as what's asking for it or how it's going to be used), all it knows is what data it contains.
- A Model can guarentee it has a valid type for each of it's properties (even if they're defaults).
- Models contain no methods.

**- More Notes**
  - In this project I've chosen to build models so that they don't (or very rarely) contain properties that are optional. 
    - This means the model and methods that use the model can be built cleaner because it doesn't need to handle optionals.
  - Instead, the model will force all properties to be defiend upon instantiation or it will hold defaults within it that are automatically set if a peroperty isn't define or a valid type.  you to provideThis means the model can be built cleaner because it doesn't need to handle optionals. 
  - Grouping data into models makes it more convenient to pass them around the various methods and views that might need them. It also helps make your code DRYer and therefore safer (because you're less likely to forget a property or miss-type something) and cleaner (because you don't need to retype everythign constantly.)

```swift
struct Emotion {
    var name: String
    var adj: String
    var valence: Double
    var arousal: Double
}

extension Emotion {
    init(_ emotionDictionary: [String:Any]) {
    self.name        = emotionDictionary["name"] as! String
    self.adj         = emotionDictionary["adj"] as! String
    self.valence     = emotionDictionary["valence"] as! Double
    self.arousal     = emotionDictionary["arousal"] as! Double
    }
}

```
  		
  - *Example: **Emotion** is a model (struct) in this project.*
    -  *It contains a **name** property (String), **adj** property (String), **valence** property (Double) and an **arousal** property (Double).*
    - *These properties all help describe an Emotion (the model), so it makes sense to group these properties together instead of trying to manage them 
  
#### - Model Controllers (MC)
**Handling Data**
  - Model Controllers
  
#### - View Controllers (VC)
**User Interaction**
  - Kn
  child view controller
  
#### - Views (V)
**What you see**
  - A View is any physical object on the screen.
  - The view will explain how to present the data it's given.
  - Views know nothing about anything except what it is.
