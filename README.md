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

##To get started:

1. Create your Bluemix application and services as defined in [Part 5: Set up the Bluemix application environment](http://wp.me/p3SYzM-5l)

2. Clone the InterConnect2016 branch of this git repository:

   `git clone -b InterConnect2016 https://github.com/dschultz-mo/Doorbell`

3. Replace all the placeholders in the following two files with values for your environment:

   * iOSClient/doorbell/doorbell.plist
   * RaspberryPi_Node-RED/ProcessDoorbell.json

### Raspberry Pi
1. Setup the hardware per [Part 1: Setting up the Raspberry Pi hardware](http://wp.me/p3SYzM-4t)
2. Setup the software per [Part 2: Raspberry Pi software](http://wp.me/p3SYzM-4w)
3. Import the three flows in **RaspberryPi_Node-RED** into the Node-RED editor on your Raspberry Pi.  To do this:
   1. Open the Node-RED flow editor (http://your-pi-address:1880/)
   2. Copy the contents of one of the flow json files in **RaspberryPi_Node-RED** into your clipboard.
   3. In Node-RED, **Import > Clipboard**
   4. Paste the json into the dialog and click **OK**.
   5. Place the flow on the canvas.
   6. Repeat steps 2-5 for the other two flows.
   7. Deploy

### Mobile app

4. Install required Pods into the XCode workspace

   ```
   cd Doorbell/iOSclient
   pod install
   ```
5. Open doorbell.xcworkspace and build.
