MobileFirst Platform - iOS SDK
===

This package contains the required native components to interact with the IBM
MobileFirst Platform.  The SDK manages all the communication and security integration between
the client and with the MobileFirst Platform.



###Installation
The SDK may be installed either by downloading the frameworks directly from this repository
or by installing desired frameworks from [CocoaPods](http://cocoapods.org/). Using CocoaPods
can significantly shorten the startup time for new projects and lessen the burden of managing
library version requirements as well as the dependencies between them.

To install CocoaPods, please see [CocoaPods Getting Started](http://guides.cocoapods.org/using/getting-started.html#getting-started).

###Contents
The complete SDK consists of a collection of pods that correspond to functions exposed
by the MobileFirst Platform.  This allows maximum flexibility, as the developer is able to
pick and choose the pods required for a given application. The MobileFirst Platform SDK contains the following
pods, any of which may be added to your project:

- CloudantToolkitLocal - This is the module for data support
- IMFDataLocal - This module implements security integration between the MobileFirst Platform and Cloudant Toolkit.

###Supported iOS Levels
- iOS 7
- iOS 8


*Licensed Materials - Property of IBM
(C) Copyright IBM Corp. 2014, 2015. All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.*

[Terms of Use](https://hub.jazz.net/gerrit/plugins/gerritfs/contents/imflocalsdk%2Fimf-ios-sdk/refs%2Fheads%2Fmaster/License.txt)
