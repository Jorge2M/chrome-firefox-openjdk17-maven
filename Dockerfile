FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu

RUN apt-get update -y \
	&& apt -y install locales \
	&& apt-get install -y wget \
	&& apt-get install -y gnupg2 \
	&& apt-get -qqy dist-upgrade \
	&& apt-get -y install curl \
	&& apt-get -qqy install software-properties-common gettext-base unzip \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#============
# Maven
#============
#RUN wget --no-verbose -O /tmp/apache-maven-3.8.3-bin.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz && \
#    tar xzf /tmp/apache-maven-3.8.3-bin.tar.gz -C /opt/ && \
#    ln -s /opt/apache-maven-3.8.3 /opt/maven && \
#    ln -s /opt/maven/bin/mvn /usr/local/bin  && \
#    rm -f /tmp/apache-maven-3.8.3-bin.tar.gz
RUN apt-get update -y \
    && apt-get install -y maven

#=======
# Chrome
#=======
#List of versions in https://www.ubuntuupdates.org/ppa/google_chrome
ARG CHROME_VERSION=120.0.6099.109-1
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable=$CHROME_VERSION \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

#Install Google Chrome Stable
#List of versions in https://www.ubuntuupdates.org/ppa/google_chrome
#RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#  apt-get install -y wget gnupg && \
#  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb stable main' >> /etc/apt/sources.list.d/google-chrome.list && \
#  apt-get update && \
#  apt-get install -y  --no-install-recommends \
#  google-chrome-stable \
#  fonts-ipafont-gothic \
#  fonts-wqy-zenhei \
#  fonts-thai-tlwg \
#  fonts-kacst ttf-freefont && \
#  rm -fr /var/lib/apt/lists/* && \
#  apt-get purge --auto-remove -y curl && \
#  rm -fr /src/*.deb

#========= 
# Firefox
#========= 
#List of versions in https://download-installer.cdn.mozilla.net/pub/firefox/releases/
ARG FIREFOX_VERSION=105.0.1
RUN FIREFOX_DOWNLOAD_URL=$(if [ $FIREFOX_VERSION = "latest" ] || [ $FIREFOX_VERSION = "nightly-latest" ] || [ $FIREFOX_VERSION = "devedition-latest" ]; then echo "https://download.mozilla.org/?product=firefox-$FIREFOX_VERSION-ssl&os=linux64&lang=en-US"; else echo "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2"; fi) \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install firefox \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 $FIREFOX_DOWNLOAD_URL \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox
 
RUN apt-get update -qqy \
	&& apt-get -qqy install xvfb \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*
