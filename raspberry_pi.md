- [Projects](#projects)
- [Languages](#languages)
  * [Go](#go)
  * [.NET core](#net-core)
- [Links](#links)
  * [Docker](#docker)
  * [Google Assistant and Dialogflow](#google-assistant-and-dialogflow)
  * [Zigbee](#zigbee)
  * [Bluetooth](#bluetooth)
- [Camera](#camera)
  * [Commands](#commands)
- [Infrared IR](#infrared-ir)
____

## Projects

- [On/Off Project - Switch a light on/off using your smart phone](http://projects.privateeyepi.com/home/on-off-project)

## Languages

### Go

- [EMBD](http://embd.kidoman.io/)
- [brian-armstrong/gpio](https://github.com/brian-armstrong/gpio)
- [stianeikeland/go-rpio](https://github.com/stianeikeland/go-rpio)
- [technomancers/piCamera](https://github.com/technomancers/piCamera)
- [brentpabst/wxcam](https://github.com/brentpabst/wxcam)
- [paypal/gatt](https://github.com/paypal/gatt)

### .NET core

- [.NET Core on Raspberry Pi](https://github.com/dotnet/core/blob/master/samples/RaspberryPiInstructions.md)
- [Running .NET Core on Raspberry Pi Raspbian](https://www.leowkahman.com/2017/07/16/running-dotnet-core-on-raspberry-pi-raspbian/)
- [Build .NET Core apps for Raspberry Pi with Docker](https://blog.alexellis.io/dotnetcore-on-raspberrypi/) with an example of multi-stage docker Build

## Links

- [Specifications](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications)
- [Changing the Raspberry Pi Keyboard
  Layout](https://thepihut.com/blogs/raspberry-pi-tutorials/25556740-changing-the-raspberry-pi-keyboard-layout)
- [Camera
  Configuration](https://www.raspberrypi.org/documentation/configuration/camera.md)
- [Library
  python3-picamera](https://www.raspberrypi.org/documentation/usage/camera/python/README.md)
- [Technical Spec - Camera
  module](https://www.raspberrypi.org/documentation/hardware/camera/README.md)
- [Raspicam
  commands](https://www.raspberrypi.org/documentation/usage/camera/raspicam/README.md)
- [Getting started with camera - official
  guide](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera)
- [Pimoroni Enviro pHAT](https://shop.pimoroni.com/products/enviro-phat)

### Docker

- [Docker ARMv7 images](https://hub.docker.com/u/arm32v7/)
- [Docker ARMv6 images](https://hub.docker.com/u/arm32v6/)
- [resin.io Docker images](https://hub.docker.com/u/resin/)
- [Serverless by use-case: Alexa skill for
  Dockercon](https://blog.alexellis.io/serverless-alexa-skill-mobymingle/)
- [Live stream to YouTube with your Raspberry Pi and
  Docker](https://blog.alexellis.io/live-stream-with-docker/)
- [Get Started with Docker on Raspberry
  Pi](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/)


### Google Assistant and Dialogflow

- [Introduction to the Google Assistant Library](https://developers.google.com/assistant/sdk/guides/library/python/)
- [Introduction to the Google Assistant Service](https://developers.google.com/assistant/sdk/guides/service/python/)
- [Comparing Google Assistant Library and Service](https://developers.google.com/assistant/sdk/overview#features)
- [Google Assistant SDK - Release Notes](https://developers.google.com/assistant/sdk/release-notes)
- [Guide: Google Assistant on Raspbian](https://www.raspberrypi.org/forums/viewtopic.php?t=188958)
- [Dialogflow Basics](https://dialogflow.com/docs/getting-started/basics)
- [Dialogflow - Supported Languages](https://dialogflow.com/docs/reference/language)
- [Comparison of kits other than Raspberry Pi](https://developer.android.com/things/hardware/index.html)
- [Extending the Google Assistant with Google Actions](https://developers.google.com/actions/extending-the-assistant)
- [Google Action API](https://developers.google.com/actions/reference/rest/Shared.Types/AppRequest)
- [Google Assistant Design Checklist](https://developers.google.com/actions/design/checklist)
- [Google Action samples](https://developers.google.com/actions/samples/)
- [Google Action - Distribute your Actions](https://developers.google.com/actions/distribute/)
- [Google Assistant - Locales](https://developers.google.com/actions/support/)
- [Integrating Smart Home Devices with the Google Assistant](https://www.youtube.com/watch?v=XdZXpFBvTP8)
- [Building a Chatbot with Dialogflow and Google Cloud Platform](https://www.youtube.com/watch?v=5r4AAIfe4Rw)

### Zigbee

- [RaspBee](https://www.dresden-elektronik.de/raspbee/)
- [RaspBee - User Manual](https://www.dresden-elektronik.de/fileadmin/Downloads/Dokumente/Produkte/ZLL/RaspBee-BHB-en.pdf)
- [ConBee](https://www.dresden-elektronik.de/conbee/)
- [deCONZ REST API - documentation](http://dresden-elektronik.github.io/deconz-rest-doc/) (for Raspbee and ConBee)
- [deCONZ REST API - code](https://github.com/dresden-elektronik/deconz-rest-plugin) (for Raspbee and ConBee)
- [Phoscon App Beta](https://github.com/dresden-elektronik/phoscon-app-beta) (a web app based on deCONZ REST API)
- [Connecting XBee to Raspberry Pi](https://dzone.com/articles/connecting-xbee-raspberry-pi)
- ZigBee Alliance has been renamed as [CSA (Connectivity Standards
  Alliance)](https://csa-iot.org/)
- [Matter](https://csa-iot.org/all-solutions/matter/) is created by CSA and it
  works with
  * Zigbee
  * [Thread](https://www.threadgroup.org/)
    + has a lower energy consumption and better security (end-to-end encryption
      in the mesh network)
    + it does not work with Home Assistant yet
  * WiFi
  * Bluetooth

### Bluetooth

- [Scan For BLE iBeacon Devices With Golang On A Raspberry Pi Zero W](https://www.thepolyglotdeveloper.com/2018/02/scan-ble-ibeacon-devices-golang-raspberry-pi-zero-w/)

## Camera

### Commands

##### To capture a picture

```sh
libcamera-still -o test.jpg
```

##### To capture a video

```sh
libcamera-vid --codec h264 -t 5000 -o test.h264
```

Note that the following codecs are available.

- `h264` (default)
- `mjpeg`
- `yuv420`

##### To stream a video

```sh
libcamera-vid -t 0 --inline --listen -o tcp://0.0.0.0:30000
```

To connect to the stream, the following URL can be used.

```
tcp/h264://pi4:30000
```

Note that the following firewall rule may need to be enabled.

```sh
sudo ufw allow in on tailscale0 to any port 30000
```

## Infrared IR

Install `lirc` (Linux infrared remote control) and verify the installation.

```sh
sudo apt update && sudo apt upgrade -y && sudo apt install -y lirc
lircd --version
```

Reboot and check if the service has been started correctly.

```sh
sudo reboot
sudo /etc/init.d/lircd status
```
