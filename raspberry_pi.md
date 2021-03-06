- [Projects](#projects)
- [Languages](#languages)
- [Links](#links)
- [Prepare Respbian on a SD card](#prepare-respbian-on-a-sd-card)
- [Initial setup](#initial-setup)
- [Installing Docker (see [detail](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/))](#installing-docker-see-detailhttpblogalexellisiogetting-started-with-docker-on-raspberry-pi)
____

### Projects

- [On/Off Project - Switch a light on/off using your smart phone](http://projects.privateeyepi.com/home/on-off-project)

### Languages

##### Go

- [EMBD](http://embd.kidoman.io/)
- [brian-armstrong/gpio](https://github.com/brian-armstrong/gpio)
- [stianeikeland/go-rpio](https://github.com/stianeikeland/go-rpio)
- [technomancers/piCamera](https://github.com/technomancers/piCamera)
- [brentpabst/wxcam](https://github.com/brentpabst/wxcam)
- [paypal/gatt](https://github.com/paypal/gatt)

##### .NET core

- [.NET Core on Raspberry Pi](https://github.com/dotnet/core/blob/master/samples/RaspberryPiInstructions.md)
- [Running .NET Core on Raspberry Pi Raspbian](https://www.leowkahman.com/2017/07/16/running-dotnet-core-on-raspberry-pi-raspbian/)
- [Build .NET Core apps for Raspberry Pi with Docker](https://blog.alexellis.io/dotnetcore-on-raspberrypi/) with an example of multi-stage docker Build

###### Installing .NET Core runtime

```sh
sudo apt-get update
sudo apt-get install curl libunwind8 gettext
curl -sSL -o dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Runtime/release/2.0.0/dotnet-runtime-latest-linux-arm.tar.gz
sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
sudo ln -s /opt/dotnet/dotnet /usr/local/bin
```

### Links

- [Specifications](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications)
- [Changing the Raspberry Pi Keyboard Layout](https://thepihut.com/blogs/raspberry-pi-tutorials/25556740-changing-the-raspberry-pi-keyboard-layout)
- [Camera Configuration](https://www.raspberrypi.org/documentation/configuration/camera.md)
- [Library python3-picamera](https://www.raspberrypi.org/documentation/usage/camera/python/README.md)
- [Technical Spec - Camera module](https://www.raspberrypi.org/documentation/hardware/camera/README.md)
- [Raspicam commands](https://www.raspberrypi.org/documentation/usage/camera/raspicam/README.md)
- [Getting started with camera - official guide](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera)
- [Pimoroni Enviro pHAT](https://shop.pimoroni.com/products/enviro-phat)

##### Docker

- [Docker ARMv7 images](https://hub.docker.com/u/arm32v7/)
- [Docker ARMv6 images](https://hub.docker.com/u/arm32v6/)
- [resin.io Docker images](https://hub.docker.com/u/resin/)
- [Serverless by use-case: Alexa skill for Dockercon](https://blog.alexellis.io/serverless-alexa-skill-mobymingle/)
- [Live stream to YouTube with your Raspberry Pi and Docker](https://blog.alexellis.io/live-stream-with-docker/)

##### Google Assistant and Dialogflow

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

##### Zigbee

- [RaspBee](https://www.dresden-elektronik.de/raspbee/)
- [RaspBee - User Manual](https://www.dresden-elektronik.de/fileadmin/Downloads/Dokumente/Produkte/ZLL/RaspBee-BHB-en.pdf)
- [ConBee](https://www.dresden-elektronik.de/conbee/)
- [deCONZ REST API - documentation](http://dresden-elektronik.github.io/deconz-rest-doc/) (for Raspbee and ConBee)
- [deCONZ REST API - code](https://github.com/dresden-elektronik/deconz-rest-plugin) (for Raspbee and ConBee)
- [Phoscon App Beta](https://github.com/dresden-elektronik/phoscon-app-beta) (a web app based on deCONZ REST API)
- [Connecting XBee to Raspberry Pi](https://dzone.com/articles/connecting-xbee-raspberry-pi)

##### Bluetooth

- [Scan For BLE iBeacon Devices With Golang On A Raspberry Pi Zero W](https://www.thepolyglotdeveloper.com/2018/02/scan-ble-ibeacon-devices-golang-raspberry-pi-zero-w/)

### Prepare Respbian on a SD card

##### On Linux

```sh
curl -f https://downloads.raspberrypi.org/raspbian_lite_latest -o raspbian.zip
unzip raspbian.zip
lsblk
sudo umount /dev/sdX1
sudo umount /dev/sdX2
sudo dd bs=4M if=2017-11-29-raspbian-stretch-lite.img of=/dev/sdX conv=fsync
```

##### On Mac

```sh
curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o raspbian.zip
unzip raspbian.zip
diskutil list
diskutil unmount /dev/diskX
sudo dd bs=1m if=2017-11-29-raspbian-stretch-lite.img of=/dev/rdiskX conv=sync
```

### Initial setup

Change to the directory with Raspbian SD card mounted and execute the following script.

```sh
cat > wpa_supplicant.conf << 'EOT'
country=GB
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="my-ssid"
  psk="my-password"
}
EOT
cat >> config.txt << 'EOT'
# To lower GPU usage (assuming headless)
gpu_mem=16
EOT
touch ssh
```

### Installing Docker (see [detail](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/))

```sh
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
```
