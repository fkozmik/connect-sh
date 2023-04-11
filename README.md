# Connect
Attention ! This is a work in progress, it can and will be improved over time.

If you're like me and have to connect to your clients' instances in a pinch, this is quite helpful.

## Features
* List your existing connections.  
This script uses `~/.ssh/config` and only shows your programmed `Hosts` connections in order to ease access to your clients.  
It also uses `docker ps --format`to list running docker containers.

* Create a new connection in `.ssh/config`.  
A few lines will create your distant environment in the config file.

* Connect to your devices.  
The whole point of the script is to connect to your clients.  
Fist use `connect.sh -l` to list your connections  
And use `connect.sh -h` to display Help.

## How to use
Clone the repository wherever you want
```bash
git clone repo
cd repo
chmod u+x ./connect.sh
./connect.sh
```

You can as well create an alias or a function in your `.bashrc` file for an even easier access
```bash
alias connect='/path/to/connect.sh'
# OR
function connect{
/path/to/connect.sh
}
```
