

# The Self App - IOS
Some documentation and ongoing notes by the author during the development of this project.

- [**Methodology**](#programming-design--methodology)
- [**M-MC-VC-V**](#m-mc-vc-v)
- [**Models**](#models-m)
- [**Model Controllers**](#model-controllers-mc)
- [**View Controllers**](#view-controllers-vc)
- [**Views**](#views-v)

# Programming Design + Methodology
This isn't necessarily "the correct" methodology or even a real methodology, but it'll help explain how this app has been developed and how the project is structured.

The chosen design pattern "M-MC-VC-V" is built on the popular MVC design and around various other design patterns (there are lots out there). 

In M-MC-VC-V, code is distinguished into 2 categories: It either concerns handling **Data** *(Model)* or handling **Interaction** *(View)*. These sections are then distinguished again as either **Defining Code** *(Itself)* or **Method Code** *(Controller)*.

**What's what?**
Model -- If the code is defining the structure, properties or type of an object the user won't see or directly interact with then it is Model code. An example would be code that defines an object called "Message" with a property called sender and a property called messageText. You could also think of the Model as being brain cells that each hold some information.

Model Controller -- If the code is defining how to process or create something the user won't directly see or interact with then it is Model Controller Code. This code manages the model, giving it methods that make the data it holds useful. An example might be code that defines a method called sendMessage, which requires a Message parameter. You could also think of this as being the brain itself, which makes use of brain cells to do stuff.

View Controller -- 
View --  If the code is defining the structure, properties or type of something the user will see or directly interact with then it is View code.
View code is made up of The View which 
If the code defines a structure, properties, pattern or type then it 

Example along with analogy:
Model: Code Defining Data

MC: 

Think of the Model as being the head

## "M-MC-VC-V"

### Models (M)
**'The Data'** -- A Model is an object containing multiple types of data that, when combined, describe something more significant.



**-- Key points**
- The Model is absolute, it doesn't know or care about the context around itself (such as what's asking for it or how it's going to be used), all it knows is what data it contains.
-- *This means it's more versatile and can be used in different contexts.*

- Models can guarantee it has a valid type for each of its properties.
-- *This means methods and views that use the model's properties won't have to perform any checks.*

- Model properties can't be optional.
-- *This helps keep the model valid for all use cases. (see above).*
-- *Models can define appropriate defaults for missing data.*
-- *If a context can only provide partial data for the model then either:
-- -  A) The data should be stored as a Dictionary or Tuple until it is valid and can instantiate the model, 
-- - B) If it's a recurring problem, a new model should be built to store the partial version of the model.*

- Models contain no methods.
-- Functionality and processing of the data is kept with Model Controllers.



**-- More Notes**

- In this project I've chosen to build models so that they don't (or very rarely) contain properties that are optional.

- This means the model and methods that use the model can be built cleaner because it doesn't need to handle optionals.

- Instead, the model will force all properties to be defined upon instantiation or it will hold defaults within it that are automatically set if a property isn't define or a valid type.  you to provide. This means the model can be built cleaner because it doesn't need to handle optionals.

- Grouping data into models makes it more convenient to pass them around the various methods and views that might need them. It also helps make your code DRYer and therefore safer (because you're less likely to forget a property or miss-type something) and cleaner (because you don't need to retype everythign constantly.)



```swift
struct Emotion {
var name: String
var adj: String=
var valence: Double
var arousal: Double
}

extension Emotion {
init(_ emotionDictionary: [String:Any]) {
self.name  = emotionDictionary["name"] as! String
self.adj = emotionDictionary["adj"] as! String
self.valence = emotionDictionary["valence"] as! Double
self.arousal = emotionDictionary["arousal"] as! Double
}
}
```

- *_Example:_ ****_Emotion_**** _is a model (struct) in this project._*

-  *_It contains a_ ****_name_**** _property (String),_ ****_adj_**** _property (String),_ ****_valence_**** _property (Double) and an_ ****_arousal_**** _property (Double)._*

- *These properties all help describe an Emotion (the model), so it makes sense to group these properties together instead of trying to manage them

#### - Model Controllers (MC)

****Handling Data****

- Model Controllers

#### - View Controllers (VC)

****User Interaction****

- Kn

child view controller

#### - Views (V)

****What you see****

- A View is any physical object on the screen.

- The view will explain how to present the data it's given.

- Views know nothing about anything except what it is.
