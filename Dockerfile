# syntax = docker/dockerfile:1.4
FROM docker-wine

ARG USERNAME=wineuser
ARG USERHOME=/home/${USERNAME}
ARG KAKAOTALK_VERSION="3.4.4.3282"

ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US:en"

# Install prerequisites
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    fonts-nanum \
    fonts-nanum-extra \
    tree \
    xterm \
    && rm -rf /var/lib/apt/lists/*

ENV WINEPREFIX=${USERHOME}/.wine
ENV WINEARCH=win32

RUN xvfb-run winetricks -q 7zip d3dx11_43 gdiplus

COPY ./installer/KakaoTalk_Setup_${KAKAOTALK_VERSION}.exe ${USERHOME}/KakaoTalk_Setup.exe
# ADD https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe ${USERHOME}/KakaoTalk_Setup.exe

# Install KakaoTalk_Setup.exe in GUI using x11docker
# ARG DISPLAY
# RUN xterm

# Install KakaoTalk_Setup.exe silently
RUN wine ${USERHOME}/KakaoTalk_Setup.exe /S

ENTRYPOINT ["/usr/bin/entrypoint", "wine", "${WINEPREFIX}/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"]
