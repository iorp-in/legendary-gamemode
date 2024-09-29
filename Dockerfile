FROM ubuntu
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install ca-certificates libc6:i386 libncurses5:i386 libstdc++6:i386 openssl:i386 gdb -y