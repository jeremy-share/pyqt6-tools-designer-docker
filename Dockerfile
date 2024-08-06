FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV HOME=/home/user

# Install necessary packages including wmctrl for window management
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        qt6-base-dev \
        qt6-tools-dev-tools \
        qt6-tools-dev \
        xvfb \
        x11vnc \
        net-tools \
        xterm \
        libxkbcommon-x11-0 \
        libxcb-xinerama0 \
        libfontconfig1 \
        fontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a user and home directory
RUN useradd -m -d $HOME user \
    && chown -R user:user $HOME

# Set working directory
WORKDIR /opt/project

# Install Python packages
RUN pip install --no-cache-dir pyqt6 pyqt6-tools

# Copy the entrypoint script
COPY entrypoint.sh /opt/project/entrypoint.sh
RUN chmod +x /opt/project/entrypoint.sh

# Switch to non-root user
USER user

# Set entrypoint
ENTRYPOINT ["/opt/project/entrypoint.sh"]
