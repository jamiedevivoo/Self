![Issues](https://img.shields.io/github/issues/jamiedevivoo/Self.svg)
![Forks](https://img.shields.io/github/forks/jamiedevivoo/Self.svg)
![Stars](https://img.shields.io/github/stars/jamiedevivoo/Self.svg)
![Tweet](https://img.shields.io/twitter/url/https/github.com%2Fjamiedevivoo%2FSelf.svg)
![License](https://img.shields.io/github/license/jamiedevivoo/Self.svg) - 
[Included](#whats-included) - 
[Requirements](#requirements) - 
[Quick Start](#quick-start)

# The Self App - IOS
Self - Your Emotional Companion. Git Repo for version control and group collaboration.

Log moods, gain insights, reflect on success and complete daily activities with a community of people focusing on improving their wellbeing and themselves.

![Screenshots](Screenshots/screenshots.png?raw=true "Screenshots")

## What's Included
- The Xcode project to build the complete app.
- Including: Pod file for installing required frameworks.
- Cloud functions for deploying to Firebase
- Including: Package file for installing required dependancies.

## Requirements

### To build the project
- The included Swift file (excluding "Cloud" folder)
- MacOS 10.14.3+
- Xcode 10.0
- IOS Device with as least Software Version 12.0
- The project is built in Swift 5
- CocoaPods 1.5.3 - Guides available [here](https://cocoapods.org/)

### Additionally, to recreate the project database
- The included "Cloud" folder
- Firebase account
- Cloud Functions
- Node.js - Guides available [here](https://www.npmjs.com/get-npm)


## Quick Start

### The Swift Xcode Project
- Download the project from [GitHub](https://github.com/jamiedevivoo/Self/)
- Unpackage and move the project to an appropriate location.
- Open Terminal and navigate to the folder. 
- e.g. ```$ cd /Users/Jamie/Desktop/Self ```
- Run pod install to install the correct versions and dependencies listed in the included podfile. 
```bash
$ pod install 
```
- Open **Self.xcworkspace**
- Clean the project workspace *'Product > Clean Build Folder'* (⇧+⌘+K)
- Build the project *'Product > Build'* (⌘+B)
- Confirm there are no compile errors
- Select a device (or simulator) and run the project *'Product > Run'* (⌘+R)

## Support + Contributing
Pull requests, feedback, advice are all are welcome.


## Authors + Acknowledgment
This project was created, researched and developed by myself. Acknowledgement goes to Bournemouth University, Dorset Mind and The Conservation Volunteers for their guidance.

## License
All rights to publish and distribute this application are reserved.

## Project Status
Project is currently in development and not ready for release.
