FROM openjdk:15.0.1-slim-buster

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_USER_HOME /var/gradle_user_home

RUN set -o errexit -o nounset \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1000 gradle \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln -s /home/gradle/.gradle /root/.gradle

VOLUME /home/gradle/.gradle

WORKDIR /home/gradle

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        fontconfig \
        unzip \
        wget \
        \
        bzr \
        git \
        git-lfs \
        mercurial \
        openssh-client \
        subversion \
    && rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION 6.7.1
ARG GRADLE_DOWNLOAD_SHA256=3239b5ed86c3838a37d983ac100573f64c1f3fd8e1eb6c89fa5f9529b5ec091d
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version

RUN gradle wrapper --gradle-version ${GRADLE_VERSION} --distribution-type all; ./gradlew --version

ARG jdk_major_version=15
ARG jdk_minor_version=0.1
ARG jdk_patch_version=9
ARG jdk_version=${jdk_major_version}.${jdk_minor_version}_${jdk_patch_version}
ARG jdk_version_encoded=${jdk_major_version}.${jdk_minor_version}%2B${jdk_patch_version}

ARG architecture_x64=x64
ARG architecture_aarch64=aarch64
ARG architecture_arm=arm

ARG operating_system_linux=linux
ARG operating_system_windows=windows
ARG operating_system_mac=mac

RUN  apt-get update \
  && apt-get install -y wget git unzip gcc\
  && rm -rf /var/lib/apt/lists/*


#linux
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_x64}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz -O - | tar -xz /jdk/jdk_${architecture_x64}_${operating_system_linux}/
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_aarch64}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz -O - | tar -xz /jdk/jdk_${architecture_aarch64}_${operating_system_linux}/
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_arm}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz -O - | tar -xz /jdk/jdk_${architecture_arm}_${operating_system_linux}/

#mac
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_x64}_${operating_system_mac}_hotspot_${jdk_version}.tar.gz -O - | tar -xz /jdk/jdk_${architecture_x64}_${operating_system_mac}/

RUN wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
RUN go get -u github.com/linuxkit/linuxkit/src/cmd/linuxkit



#windows
#https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7.1/OpenJDK14U-jdk_x64_windows_hotspot_14.0.1_7.zip

#COPY entrypoint.sh /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]