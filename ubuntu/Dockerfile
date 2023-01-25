# syntax = docker/dockerfile:1.4
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    apt-get update \
    && apt-get install -yq --no-install-recommends \
    apt-transport-https ca-certificates \
    gnupg gpg-agent sudo \
    supervisor wget curl unzip git vim tree tmux xterm \
    dbus-x11 cabextract winbind xvfb zenity \
    ibus ibus-hangul fonts-nanum fonts-noto-cjk

# Install firefox
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9bdb3d89ce49ec21" | gpg --dearmor -o /usr/share/keyrings/firefox.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/firefox.gpg]  https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" | tee /etc/apt/sources.list.d/firefox.list \
    && apt-get update \
    && apt-get install -yq firefox-esr \
    && ln -s /usr/bin/firefox-esr /usr/bin/firefox

# Locale and Timezone
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Asia/Seoul

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    apt-get update \
    && apt-get install -yq tzdata locales \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

# Install wine
ARG WINE_BRANCH="stable"
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
    && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" | tee /etc/apt/sources.list.d/winehq.list \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -yq --install-recommends winehq-${WINE_BRANCH}

# Install winetricks
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks

# Download gecko and mono installers
COPY download_gecko_and_mono.sh /root/download_gecko_and_mono.sh
RUN chmod +x /root/download_gecko_and_mono.sh \
    && /root/download_gecko_and_mono.sh "$(wine --version | sed -E 's/^wine-//')"

# Create an user
ARG user=wineuser
ARG uid=1000
ARG home=/home/$user

RUN adduser \
    --disabled-password \
    --gecos '' \
    --shell /bin/bash \
    --home $home \
    --uid $uid \
    $user \
    && adduser $user sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR $home
USER $user

ENV WINEARCH=win32
ENV WINE=wine
ENV WINEPREFIX=$home/.wine

RUN mkdir -p $home/.cache
RUN --mount=type=cache,id=ubuntu-winetricks,sharing=locked,target=$home/.cache/winetricks,uid=$uid \
    winetricks -q d3dx11_43 gdiplus msxml6 richtx32 \
    && winetricks -q win7

RUN --mount=type=bind,target=/data \
    wine /data/KakaoTalk_Setup.exe /S

COPY --chown=$user run_kakaotalk.sh ./

ENV GTK_IM_MODULE=ibus
ENV XMODIFIERS=@im=ibus
