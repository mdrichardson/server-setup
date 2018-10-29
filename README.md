# Server-Setup

This is my interactive bash script for setting up a Ubuntu/Apache server on an Amazon EC2 instance.

**Only tested on Ubuntu 16.04**

## Features

* Gives root priveleges to main account and enables SSH
* Installs Node.js
* Installs PostgreSQL
* Installs Apache and sets up new website with optional LetsEncrypt support

## Usage

1. Copy all files onto your server, preferably in your user folder
2. `cd` into that folder
3. Run:

```bash
bash server-setup.sh
```

You can also individually run any of the other `.sh` files.

