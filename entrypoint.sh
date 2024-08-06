#!/bin/sh

# Ensure the /tmp/.X11-unix directory exists and has the right permissions
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
chown root:root /tmp/.X11-unix

# Debugging output to verify the environment variables
echo "Starting Xvfb with resolution: ${RESOLUTION}"

# Ensure clean start
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

# Start Xvfb with the specified resolution and color depth
Xvfb :0 -screen 0 ${RESOLUTION}x24 &

# Wait for Xvfb to start
sleep 5

# Debugging output to check if Xvfb is running
# ps aux | grep Xvfb

# Start x11vnc
x11vnc -display :0 -passwd "${VNC_PASSWORD}" -forever -shared -noxdamage &

# Extract width and height from RESOLUTION
WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)

# Start Qt Designer with specified geometry
pyqt6-tools designer -geometry ${WIDTH}x${HEIGHT}+0+0

# Keep the container running
wait
