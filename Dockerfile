FROM ubuntu

COPY ./Appium /var

# Set environment variables
ENV ANDROID_HOME /var/Sdk/
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV ANDROID_PLATFORMTOOL="${ANDROID_HOME}/platform-tools"
ENV ANDROID_BUILDTOOL="${ANDROID_HOME}/build-tools/34.0.0"
ENV SDK_MANAGER="${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH="${PATH}:${ANDROID_HOME}:${ADB}"

# Create necessary directories
RUN mkdir -p /var/lib/apt/lists/partial /etc/apt/keyrings

# Install required packages
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    export NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    mkdir /var/config && \
    apt-get install -y openjdk-8-jre nodejs git vim && \
    npm i -g appium && \
    git clone https://github.com/fwany21/appium-device-farm.git && \
    git clone https://github.com/fwany21/appium-uiautomator2-driver.git && \
    cd /appium-uiautomator2-driver && npm install && cd /appium-device-farm && npm install && cd / && \
    appium driver install --source=local /appium-uiautomator2-driver/ && \
    appium plugin install --source=local /appium-device-farm/ && \
    appium plugin install --source=npm appium-dashboard