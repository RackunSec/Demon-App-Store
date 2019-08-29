![Demon App Store Logo](images/app-store-logo.png)

Finally, the Demon App Store is here! This, technically, should work with any Debian 10 distribution.
## The Store UI
![Demon App Store Screenshot](images/screenshot-app-store.png)

## Self Maintaining
The Demon App Store will update itself in /appdev/ before each run. This is due to the ```demon-app-store-workflow.sh``` file which is stored in ```/usr/local/sbin/``` which holds all of the working code.

### Integrity Checks
All application files are checked for integrity before re-downloading using hard-coded md5 hashes,
```
[+] $app: Graphana
[+] Checking if Graphana is already installed ...
[+] Cached file found: /var/demon/store/app-cache/grafana_6.3.3_amd64.deb
[+] Checksum verified, [ OK ]
```
This makes the Demon App Store more efficient by saving bandwidth.

#### Dependencies
* wget
* awk, sed, grep
* apt
* git
* yad
* tail
* dpkg
* curl
* add-apt-repository
