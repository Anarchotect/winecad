# winecad
Docker container for CAD using Windows Emulator

This container includes packages for a Windows Emulator and some tools I use for 3D printing

To use my X11 environment within the container I'll generally use a shell alias:
```
winecad='xdock -e WINEPREFIX=/home/$USER/WineCAD'
xdock='docker run -it --rm --network=host -e USER=$USER -e UID=$UID -e DISPLAY=$DISPLAY -v $HOME:/home/$USER -v /tmp/.X11-unix:/tmp/.X11-unix:rw --workdir=/home/$USER --entrypoint=./.xdock'
```
In my home directory I keep a script `.xdock`:
```
#!/bin/sh

[ -e '/bin/zsh' ] && SHELL='/bin/zsh' || SHELL='/bin/bash'
useradd -m -U -G "sudo" -u "${UID}" "${USER}" -s "${SHELL}"
su -w DISPLAY "${USER}"
```
