# Raspberry Pi Network Availability Ping Server

## Overview

The _Raspberry Pi Network Availability Ping Server_ is a simple Raspberry Pi project 
that is designed to help you monitor 
the availability of an external WAN from a local LAN.
The Ping Server monitors connectivity to the external network by continuously 
pinging the DNS Server used by the modem's ISP.

The Ping Server is intended to be connected to the LAN via hard-wired ethernet 
cable to the router or switch that is 
used to connect to the external WAN.
It is _not_ intended to monitor the quality, 
status or availability of a Wi-Fi connection to the router.
However, it is possible to configure the Pi to use Wi-Fi for its network connection and 
therefore monitor both the availability of the Wi-Fi connection and the external WAN together.

----
## Prerequisite Hardware

### Required Components

#### Raspberry Pi Computer

<img src="https://images-na.ssl-images-amazon.com/images/I/814a-VSPKHL._AC_SL1476_.jpg" width="50%" height="50%" />

[Raspberry Pi Starter Kit on Amazon](https://www.amazon.com/ABOX-Raspberry-Complete-Motherboard-Heatsink/dp/B07D8VXWRY/)

----
#### Admin User Interface

There are two ways to install, configure and administer the Raspberry Pi's hardware and software:
- Physically attach a dedicated display, keyboard and mouse to the Raspberry Pi (recommended)
- Remotely connect to the Raspberry Pi via a network attached computer using SSH and VnC or using SSH alone

##### Local Display/Keyboard/Mouse

If you are planning to install the Raspberry Pi with local dedicated devices,
you will need the following:
- HDMI Compatible TV/monitor and an HDMI cable
- USB Keyboard
- USB Mouse

##### Remote Computer

If you are planning to install the Raspberry Pi without a physical monitor or keyboard being present (i.e. headless),
you will need the following:
- A desktop computer or laptop attached to the same local area network as the Raspberry Pi
- An open Terminal window on the computer capable of running the **ssh** command.
- Optionally (recommended), install a VnC client on your computer providing full remote
access to the Raspberry Pi desktop. 
The [VnC Viewer](https://www.realvnc.com/en/connect/download/viewer/) from RealVnC is
available on several platforms, is free for non-commercial use and has been found to work very reliably with the Raspberry Pi VnC server.

----
### Optional Hardware Components

#### LED Traffic Lights

<img src="https://m.media-amazon.com/images/I/81qS7K8xMXL._AC_SL1500_.jpg" width="25%" height="25%" />

[LED Traffic Lights on Amazon](https://www.amazon.com/Pi-Traffic-Light-Raspberry/dp/B00P8VFA42/)

##### When the optional LED Traffic Lights are installed, the Ping Server states are shown as follows: 
- LED yellow - Program starting
- LED yellow & green - Network going up
- LED green - Network up
- LED red & yellow - Network going down
- LED red - Network down
- LED blinking red - Network not connected

----
#### USB Speaker

<img src="https://images-na.ssl-images-amazon.com/images/I/619fDIrwrHL._AC_SL1000_.jpg" width="50%" height="25%" />

[USB Speaker on Amazon](https://www.amazon.com/gp/product/B075M7FHM1/)

----

## Hardware Installation Steps

### Assemble the Raspberry Pi Computer
- Install the Raspberry Pi motherboard in the case
- Attach the two heat sinks to the motherboard
- Attach the case cover to the case

### Install the Raspberry Pi OS on a Micro SD Card
- Download and Install the free [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
- Place a blank micro SD card into an SD card reader/writer and insert it into the computer
- Open the **Raspberry Pi Imager** (or equivalent micro SD card writer)
```
> Select Operating System: Raspberry Pi OS (32-bit)
```
- After clicking Select Device, but before selecting the specific device, 
make a note of the full path where the SD Card has been mounted on this computer.
```
> Select Device: Choose the appropriate SD Card reader
> Select Write
```
**Note:** Writing the OS to the SD card can take some time.

When complete, if you are using real console devices, skip ahead to 
_Final Assembly of the Raspberry Pi Computer_.

##### Headless Only
Otherwise, if you are planning a headless installation, you must enable **ssh** on boot
by adding a file to the boot directory of the micro SD card.

Open a terminal window on the computer with the SD card writer and perform the below commands.
You may need to remove and reinsert the SD card reader/writer 
for the newly created SD card volume to be recognized by the computer.
```
> cd <Directory where the SD Card in mounted on this computer>
> touch ssh
```
**Note:** the **ssh** file only needs to exist. An empty file is OK, 
as the contents of the file does not matter.

Now, close the Terminal window and properly eject the SD card reader/writer.

### Final Assembly of the Raspberry Pi Computer
- Remove the micro SD card from the SD card reader and 
insert it into the Raspberry Pi motherboard
- Attach a LAN Ethernet cable to the Raspberry Pi
- Attach the power supply to the Raspberry Pi
- If **not** headless, attach the monitor, keyboard and mouse, 
power up the Raspberry Pi, and then skip ahead to _Configure the Raspberry Pi OS Settings._

### Headless Initial Configuration of the Raspberry Pi
- Open a terminal window on your computer
- Power up the Raspberry Pi
- Once the Raspberry Pi has finished booting and has connected to the network, 
it will start responding to the ping command.
If you haven't already done so, make a note of the IP address.
```
> ping raspberrypi.local
```
- Make an initial connection to the Raspberry Pi using the **ssh** command.
- For now, just use the the default password of **raspberry**.
It is easier to wait until the upcoming _Raspberry Pi Setup_ wizard to permanently 
change the default password for the default user **pi**.
```
> ssh pi@raspberrypi.local
> passwd: raspberry
```
- Next, enable the **VnC Server** setting to make the Raspberry Pi graphical desktop available remotely.
```
> sudo raspi-config
> select Interface Options
> select P3 VNC 
> select Yes
> select OK
```
- Is is very helpful to change the default display resolution setting 
if you are planning to connect to the graphical desktop using VnC Viewer.
```
> select Display Options
> select D1 Resolution
> select DMT Mode 82 1920x1080 60Hz 16:9
> select OK
> select finish
> Reboot: Yes
```
- This will close the **ssh** session.
- Now, on your computer, open a **VnC Viewer** to get access to the Raspberry Pi graphical desktop.
```
> Open VNC Viewer
> Select 'New Connection...' from the 'File' menu
> For 'VNC Server' enter 'raspberrypi.local'
> For 'Name' enter a name meaningful to you
> OK
> Right-click the new Connection icon and select 'Connect'
(It may tell you that the VNC Server identity check has failed.)
> click 'Continue'
> Username: 'pi'
> Password: 'raspberry'
> OK
```
- When the Raspberry Pi desktop opens, you will receive a warning that SSH is enabled and
the default password for the **pi** user has not been changed.
- Click **OK** to continue with **Welcome to Raspberry Pi**.  
- Click **Next** to begin the **Raspberry Pi Setup Wizard** starting in the next step.

### Configure the Raspberry Pi OS Settings
At this point, if you are using the VNC Viewer to access the Raspberry Pi OS desktop,
the steps will be exactly the same as if you were using a physically attached
display, keyboard and mouse.
#### Raspberry Pi Setup Wizard
- If needed, make a note of the current IP address, then click **Next**
- Select the **Use English language** and **Use US keyboard** checkboxes
- Select a **Country**, **Language**, and **Timezone**, then click **Next**
- Now change the password for the default 'pi' account, then click **Next**
- Select the checkbox if the desktop does not fill the entire screen, then click **Next**
- If you want to use Wi-Fi, select your network, otherwise click **Skip**
- On the **Update Software** panel, click **Next** (**Note:** this may take some time)
- When finished it will notify you that the system is up to date. Click **OK**.
- At this point, the Initial Raspberry Pi Setup is essentially complete. 
- If you are currently **running headless**, click **Restart**. When the reboot is complete, 
restart the VNC Viewer and then skip down to _Software Installation Steps_.
- Otherwise, if you are currently **not running headless**, 
when asked if you want to restart, click **Later**
- Then click the **Raspberry Pi** button at the top left of the screen, select **Preferences**, 
and select **Raspberry Pi Configuration**.
- Select the **Interfaces** tab, then (if not already selected) 
select **Enable** for both VNC and for SSH. This will allow you to run headless later after the 
installation is complete.
- Click **OK**
- Click the **Raspberry Pi** button again, select **Shutdown**, and then click **Reboot**.
----
## Software Installation Steps
After the reboot is complete, all of the remaining installation steps are performed in a terminal window, 
which can be opened by clicking on the **Terminal** button at the top left of the screen.

If you haven't made a note of it already, 
the following command will tell you your Raspberry Pi's current IP address.
```
> hostname -I
```
##### Update Base Operating System
This step confirms that all of the currently install software is up to date. This should go very quickly if you did the updates in the setup wizard.
```
> sudo apt update
```
If there are no packages that need upgrading, skip ahead to _Install Swift Compiler._
```
> sudo apt upgrade
```
##### Install Swift Compiler
The following commands installs the Swift Tools, Compiler and Library for Raspberry Pi:
```
> curl -s https://archive.swiftlang.xyz/install.sh | sudo bash
> sudo apt install swiftlang
> (need to reply 'y' once, just hit return at the prompt)
```
##### Install the Ping Server
Download the public Ping Server Project from GitHub
```
> git clone https://github.com/Whiffer/PingServer
```
##### Configure and Build the Ping Server

Compile the Swift project.
```
> cd PingServer
> swift build
```

Start the PingServer and configure it to autostart at boot time.
```
> mkdir Outages
> sudo cp autostart/pingserver.service /etc/systemd/system/pingserver.service
> sudo systemctl start pingserver.service
> sudo systemctl enable pingserver.service
```

##### Install and Configure HTTP Server

After opening a terminal window, follow these steps to install and configure the HTTP server:
```
> sudo apt install nginx
> (need to reply 'y' once, just hit return at the prompt)
> sudo cp /home/pi/PingServer/nginx/nginx.conf /etc/nginx/
> sudo /etc/init.d/nginx reload
> sudo /etc/init.d/nginx start
```

##### Local Test

- Click the **Web Browser** button at the top left of the screen
- After the web browser starts, navigate to **localhost**

##### Remote Test 

- Click the **Open Applications Menu** button at the top left of the screen
- Click **Logout** then select **Reboot**
- Open a Web Browser on a computer on the same LAN and 
then navigate to **raspberrypi.local**.

----
## Operating the Ping Server

##### Stoping the Ping Server
To manually stop the PingServer, open a terminal and use this command.
```
> sudo systemctl stop pingserver.service
```
##### Updating the Ping Server
To update the PingServer from GitHub:
```
> cd PingServer
> git pull https://github.com/Whiffer/PingServer
> swift run
```
##### Starting the Ping Server
To manually start the PingServer, open a terminal and use this command.
```
> sudo systemctl start pingserver.service
```
##### Viewing the Ping Server Status
- Open a web browser on the local network
- Navigate to **raspberrypi.local**

----
## Ping Server Internal Logic

### Ping Server Program

- PingServer (Swift App)
- customize IP address for pings (e.g. Xfinity DNS is 75.75.75.75)
- writes '~/PingServer/www/CurrentStatus.js' once per second
- shows most recent ping round trip time and the minimum, maximum, 
average and standard deviation of the pings for the last minute.
- Each time an Outage is cleared, details of the Outage are written to: 
'~/PingServer/Outages/Outage_YYYY_MM_DD_HH_MM_SS.json'
- '~/PingServer/www/OutageHistory.js' is replaced after each outage is cleared

### Web Server
```
> sudo service nginx stop
> sudo service nginx start
> sudo service nginx restart
> sudo /etc/init.d/nginx reload
```

- nginx HTTP Server
- Web server root directory configured to be: '~/PingServer/www'
- index.html (browser auto reloads once per second)
- index.html embeds CurrentStatus.js and OutageHistory.js that are written by PingServer
- Direct any web browser to: raspberrypi.local or its direct IP address
----
