# syntax = docker/dockerfile:1.4
FROM docker-wine

ARG USERNAME=wineuser
ARG USERHOME=/home/${USERNAME}

ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US:en"

# Install prerequisites
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    fonts-nanum \
    vim \
    tree \
    xterm

# Configure wine
WORKDIR ${USERHOME}
ENV WINEPREFIX=${USERHOME}/.wine
ENV WINEARCH=win32

RUN --mount=type=cache,sharing=locked,target=/root/.cache/winetricks \
    xvfb-run sh -c "\
    winetricks -q 7zip d3dx11_43 gdiplus; \
    wineserver -w"

# Download and Install KakaoTalk silently
RUN wget -nv -O ./KakaoTalk_Setup.exe https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe && \
    xvfb-run sh -c "\
    wine ./KakaoTalk_Setup.exe /S; \
    wineserver -w" && \
    rm -f ./KakaoTalk_Setup.exe

RUN cat ${WINEPREFIX}/system.reg
COPY ./config/fontsmoothing.reg /tmp/fontsmoothing.reg
RUN xvfb-run sh -c "\
    wine regedit /s /tmp/fontsmoothing.reg; \
    wineserver -w"

RUN sed -i 's@"MS Shell Dlg"="Tahoma"@"MS Shell Dlg"="NanumGothic"@' ${WINEPREFIX}/system.reg && \
    sed -i 's@"MS Shell Dlg 2"="Tahoma"@"MS Shell Dlg 2"="NanumGothic"@' ${WINEPREFIX}/system.reg

