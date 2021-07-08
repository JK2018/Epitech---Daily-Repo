# This FROM command creates a layer from the ubuntu:18.04 Docker image.
FROM ubuntu:18.04


# Prerequisites
# Upon using this RUN command, all the necessary packages are downloaded and installed using apt.
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget


# Update the package list and install chrome
RUN apt-get update -y
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb 


# Set up new user
# Add a new non-root user called developer, set it as the current user, and change the working directory to its home directory.
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
# Create some folders where the Android SDK will be installed. Also, set the environment variable ANDROID_SDK_ROOT to the correct directory path—this will be used by Flutter.
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
# Download the latest SDK tools. Unzip them and move them to the correct folder. Then, we will use sdkmanager to accept the Android Licenses and download the packages that will be used during app development. Finally, I have added the path to adb.
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
RUN cd Android/sdk/tools/bin && ./sdkmanager --install "cmdline-tools;latest"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
# Set up Flutter by cloning it from the GitHub repository, and add the PATH environment variable for running flutter commands from the terminal.
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
#RUN apt-get update && apt-get -y install google-chrome-stable



RUN flutter config --enable-web
RUN flutter doctor --android-licenses


# Run basic check to download Dark SDK
# At last, run the flutter doctor command for downloading the Dart SDK and for checking whether Flutter is set up properly.
RUN flutter doctor




