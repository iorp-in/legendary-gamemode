FROM ubuntu:latest

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Add 32-bit architecture capability
RUN dpkg --add-architecture i386

# Install standard dependencies, 32-bit libraries, and timezone data
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    ca-certificates \
    gdb \
    libc6:i386 \
    libncurses6:i386 \
    libstdc++6:i386 \
    libssl3:i386 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /server

# Configure the timezone non-interactively
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Copy core shared object libraries from host root
COPY log-core.so ./log-core.so
COPY log-core2.so ./log-core2.so

# Copy the server binaries and configurations
COPY samp-server ./samp-server
COPY samp-npc ./samp-npc
COPY announce ./announce

# Copy your game asset directories
COPY plugins/ ./plugins/
COPY scriptfiles/ ./scriptfiles/

# Ensure all server components have proper Linux executable permissions
RUN chmod +x ./samp-server ./samp-npc ./announce

# Expose the default game server port (UDP)
EXPOSE 7788/udp

# Start the game server directly in the foreground
CMD ["./samp-server"]
