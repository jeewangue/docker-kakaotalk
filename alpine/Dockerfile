# syntax = docker/dockerfile:1.4
##### FAIL....
FROM alpine:3.17

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN --mount=type=cache,id=apk-x86,sharing=locked,target=/etc/apk/cache \
    echo 'x86' > /etc/apk/arch \
    && apk update \
    && apk add \
    supervisor sudo bash bash-completion \
    ca-certificates wget curl tree vim tmux openssh \
    musl musl-utils musl-locales musl-locales-lang \
    icu-dev gettext-dev libintl \
    xvfb xvfb-run x11vnc xdpyinfo zenity \
    st terminus-font font-noto-cjk \
    wine winetricks

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Asia/Seoul

RUN --mount=type=cache,id=apk-x86,sharing=locked,target=/etc/apk/cache \
    apk add tzdata \
    && echo $TZ > /etc/timezone \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && apk del tzdata

# Create an unprivileged user
ARG user=wineuser
ARG uid=1000
ARG home=/home/$user
ARG user_sudo=yes

RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell /bin/bash \
    --home $home \
    --uid $uid \
    $user

RUN if [ "$user_sudo" == "yes" ]; then \
    echo "$user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user \
    && chmod 0440 /etc/sudoers.d/$user ;\
    fi

WORKDIR $home
USER $user

ENV WINEARCH=win32
ENV WINE=wine
ENV WINEPREFIX=$home/.wine

RUN mkdir -p $home/.cache
RUN --mount=type=cache,sharing=locked,target=$home/.cache/winetricks,uid=$uid \
    winetricks -q dxvk gdiplus dotnet48 msxml6 richtx32 \
    && winetricks -q win7

RUN --mount=type=bind,target=/data \
    wine /data/KakaoTalk_Setup.exe /S


# RUN sed -i 's@"MS Shell Dlg"="Tahoma"@"MS Shell Dlg"="NanumGothic"@' ${WINEPREFIX}/system.reg && \
#     sed -i 's@"MS Shell Dlg 2"="Tahoma"@"MS Shell Dlg 2"="NanumGothic"@' ${WINEPREFIX}/system.reg


# COPY ./KakaoTalk_Setup.exe ./

# st -f 'xos4 Terminus-14'
