FROM debian:bullseye-slim
ARG DEBIAN_FRONTEND=noninteractive

ENV GECKO64=https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86_64.tar.xz
ENV CURA=https://github.com/Ultimaker/Cura/releases/download/5.6.0/UltiMaker-Cura-5.6.0-linux-X64.AppImage
ENV WINETRICKS=https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

RUN apt update && apt -y install ca-certificates

COPY apt/ /etc/apt/
RUN dpkg --add-architecture i386 && apt update && apt -y install winehq-stable winbind winetricks wget sudo zsh kdialog
RUN mkdir -p /usr/share/cura && wget ${CURA} -O /usr/share/cura/cura-5.6.0 && chmod +x /usr/share/cura/cura-5.6.0
RUN cd /usr/share/cura && ./cura-5.6.0 --appimage-extract
RUN mkdir -p /usr/share/wine/gecko && wget ${GECKO64} -O - | tar --xz -x -C /usr/share/wine/gecko
RUN wget ${WINETRICKS} -O /usr/bin/winetricks && chmod +x /usr/bin/winetricks 

RUN printf '%s\n%s\n' '#!/bin/bash' 'wine64 $WINEPREFIX/drive_c/Program\ Files/Rhino\ 7/System/Rhino.exe' > /usr/bin/rhino
RUN printf '%s\n%s\n' '#!/bin/bash' 'wine64 $WINEPREFIX/drive_c/Program\ Files/AnycubicSlicer/Anycubic-Slicer.exe' > /usr/bin/anycubic
RUN printf '%s\n%s\n' '#!/bin/bash' 'wine $WinePREFIX/drive_c/Program\ Files/AnycubicPhotonWorkshop/AnycubicPhotonWorkshop.exe' > /usr/bin/photon
RUN printf '%s\n%s\n' '#!/bin/bash' '/usr/share/cura/squashfs-root/AppRun -platformtheme gtk3' > /usr/bin/cura
RUN chmod 755 /usr/bin/rhino /usr/bin/anycubic /usr/bin/photon /usr/bin/cura
