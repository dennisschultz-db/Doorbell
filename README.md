# Doorbell

The code in this project is a completed example of my blog [My Internet of Things and MobileFirst Adventure](http://ibm.biz/IoTDoorbell).

My goal for this project was to learn what I could about interfacing a device on the Internet of Things with a mobile application.  The final product isn't something you would go to production with, but rather something that demonstrates several concepts in working code.

Some of the capabilities demonstrated here are:

* Manipulating hardware (LEDs, camera) on a Raspberry Pi using Node-RED.
* Performing operations in JavaScript functions and native OS commands in Node-RED.
* Invoking Push notifications to mobile devices from a Raspberry Pi in response to an external stimulus (pushbutton).
* Controlling an IoT device from a mobile app using the IBM IoT Foundation and MQTT.
* Transferring picture images from the Raspberry Pi to the mobile device app using the IoT Foundation
* Streaming video from the Raspberry Pi and viewing it on the mobile device app

To best understand what's in this project, I would suggest following through the multiple parts of the blog series.  You will need the following to successfully run this project:

* An OS X computer
   * Xcode
* An iPhone
* An Apple Watch
* An Apple Developer account
   * All the necessary app identifiers, provisioning profiles, etc.
* An IBM Bluemix account
* An IBM Bluemix application including
   * IBM Push Notifications service
   * IBM Internet of Things Foundation service

