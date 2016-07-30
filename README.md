# Setup Development Environment

## Install Docker

Install Docker: https://www.docker.com/docker-toolbox

## Install Atom.io
Go to https://atom.io/ then download and install atom.io. This is used as the IDE for node.js.

## Install iTerm2
Go to https://www.iterm2.com/

## Setup Local Docker Containers
```
cd ~
git clone git@github.com:noNonsenseNode/playground.git
cd ~/playground/
chmod +x run
./run setup
```

## Windows Development
Install docker "Enable virtualbox, msysys-git unix tools"  "add docker.exe to path, reboot windows"
Install git "Use git and optional unix tools….."
Add id_rsa to ~/.ssh
Open git bash, git clone
Open powershell as administrator
cd into project
```
Set-ExecutionPolicy unrestricted
./run.ps1 setup
```
use run.ps1 instead of run for all scripts

## Starting Development

## Commands

To access the container for shell access:
```
./run shell
```

To restart node process and upgrade database:
```
./run restart
```

To remove all processes:
```
./run destroy
```

# Database Changes

```
cd ~/playground/database
db-migrate create name-of-migration-script
```
This will create up and down files which can be edited to perform database changes
