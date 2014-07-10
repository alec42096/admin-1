# Fastly Example API shell scripts

## Description
These scripts are only for example use and should be used to create your own scripts for managing Fastly. They only use bash / curl and each script will focus on one particular part of the API.

While I have tried to test these scripts as thoroughly as I can there may be bugs, security holes or flat out errors as such....These scripts are provided as-is with no warranty real or implied. Use at your own risk.

## Requirements
- A working POSIX system with curl installed
- A Fastly account and user with superuser privileges.

## Getting started
These scripts all assume the presence in your home directory of a .fastly/api-creds.sh file. The contents of this file should look like:
```
#!/bin/bash

export FASTLY_API_KEY="Fastly-Key: somekey"
export FASTLY_SERVICE_ID="some_service_id"
```
This ensures that all calls use the API KEY rather than a username / password & cookie authentication scheme.

These details can be found in the [Fastly App](https://app.fastly.com/). The API key is found on the [account page](https://app.fastly.com/#account). The service ID is listed under the service name on the [configure page](https://app.fastly.com/#configure).

Once this is created you can run any script from a POSIX machine (Linux / Mac OS X / *BSD) by invoking bash followed by the name of the script, or by prepending the name of the script with './'

## Resources
[Fastly API Docs](http://docs.fastly.com/api)