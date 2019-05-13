![Issues](https://img.shields.io/github/issues/jamiedevivoo/Self.svg)
![Forks](https://img.shields.io/github/forks/jamiedevivoo/Self.svg)
![Stars](https://img.shields.io/github/stars/jamiedevivoo/Self.svg)
![License](https://img.shields.io/github/license/jamiedevivoo/Self.svg) 
![IOS](https://img.shields.io/badge/IOS-12-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-5-brightgreen.svg)
![Xcode](https://img.shields.io/badge/Xcode-10-brightgreen.svg)
![Tweet](https://img.shields.io/twitter/url/https/github.com%2Fjamiedevivoo%2FSelf.svg)

# The Self App - IOS
[Screenshots](#screenshots) -
[Included](#whats-included) - 
[Requirements](#requirements) - 
[Quick Start](#quick-start) -
[Contributing](#support--contributing) -
[License](#license) -
[Acknowledgement](#authors--acknowledgement) -
[Status](#project-status)

Self - Your Emotional Companion. Git Repo for version control and group collaboration.

Log moods, gain insights, reflect on success and complete daily activities with a community of people focusing on improving their wellbeing and themselves.

##### Screenshots
![Screenshots](https://github.com/jamiedevivoo/Self/blob/master/Screenshots/screenshots.png?raw=true "Screenshots")

## What's Included
- The Xcode project to build the complete app.
- Including: Pod file for installing required frameworks.
- Cloud functions for deploying to Firebase
- Including: Package file for installing required dependancies.
- Notes documenting the technical aspects and decisions of the project. [View Here](https://github.com/jamiedevivoo/Self/tree/master/App/Notes.md)

## Requirements

### - To build the project
- The included "App" folder
- MacOS 10.14.3+
- Xcode 10.0
- IOS Device with as least Software Version 12.0
- The project is built in Swift 5
- CocoaPods 1.5.3 - Guides available [here](https://cocoapods.org/)

### - Additionally, to deploy cloud functions for the project
- The included "Cloud" folder
- Firebase account
- Cloud Functions
- Node.js - Guides available [here](https://www.npmjs.com/get-npm)


## Quick Start

### - Compiling The Swift Xcode Project
- Download the project from [GitHub](https://github.com/jamiedevivoo/Self/)
- Unpackage and move the project to an appropriate location.
- Open Terminal and navigate to the *App* folder. 
```bash
$ cd /Users/[username]/Desktop/Self/App 
```
- Run pod install to install the correct versions and dependencies listed in the included podfile. 
```bash
$ pod install 
```
- Open **Self.xcworkspace**
- Clean the project workspace *'Product > Clean Build Folder'* (⇧+⌘+K)
- Build the project *'Product > Build'* (⌘+B)
- Confirm there are no compile errors
- Select a device (or simulator) and run the project *'Product > Run'* (⌘+R)
### - Deploying Firebase Cloud Functions
- Download the project from [GitHub](https://github.com/jamiedevivoo/Self/)
- Unpackage and move the project to an appropriate location.
- Open Terminal and navigate to the *Cloud* folder. 
```bash
$ cd /Users/[username]/Desktop/Self/Cloud 
```
- Install node and npm with homebrew in terminal
```bash
brew install node
```
- Install Firebase Commandline tools
```bash
npm install -g firebase-tools
```
- Login to firebase using the browser that pops up from running the following command
```bash
 firebase login
 ```
 - Install the firebase dependencies
 ```bash
 firebase init functions
 ```
 - Write the commands you want to deploy in TypeScript
 - Then deploy the function to Firebase Cloud Function
 ```bash
 firebase deploy --only functions
 ```
 - You can use the URL that's returned to test your function

## Support + Contributing
Pull requests, feedback, advice are all are welcome.

## License
All rights to publish and distribute this application are reserved. Others may download the project to study and/or contribute to the original, however they may not republish the application in part or in it's entirety without permission.

## Authors + Acknowledgment
This project was created, researched and developed by myself. Acknowledgement goes to Bournemouth University, Dorset Mind and The Conservation Volunteers for their guidance.

## Project Status
Project is currently in development and not ready for release.
