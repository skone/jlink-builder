FROM openjdk:15.0.1-slim-buster

ARG jdk_major_version=15
ARG jdk_minor_version=0.1
ARG jdk_patch_version=9.1
ARG jdk_version=${jdk_major_version}.${jdk_minor_version}_${jdk_patch_version}
ARG jdk_version_encoded=${jdk_major_version}.${jdk_minor_version}%2B${jdk_patch_version}

ARG architecture_x64=x64
ARG architecture_aarch64=aarch64
ARG architecture_arm=arm

ARG operating_system_linux=linux
ARG operating_system_windows=windows
ARG operating_system_mac=mac

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

#linux
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_x64}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_aarch64}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_arm}_${operating_system_linux}_hotspot_${jdk_version}.tar.gz

#mac
RUN wget https://github.com/AdoptOpenJDK/openjdk${jdk_major_version}-binaries/releases/download/jdk-${jdk_version_encoded}/OpenJDK${jdk_major_version}U-jdk_${architecture_x64}_${operating_system_mac}_hotspot_${jdk_version}.tar.gz

#windows
#https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7.1/OpenJDK14U-jdk_x64_windows_hotspot_14.0.1_7.zip

#COPY entrypoint.sh /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
