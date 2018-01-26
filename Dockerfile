FROM frolvlad/alpine-gcc:latest

LABEL maintainer="chris.rohrer@ubuntunet.net"

ARG WPA_SUPPLICANT_VERSION=2.6

WORKDIR /eapol

RUN apk update && apk upgrade && \
    apk add --update linux-headers make openssl openssl-dev && \
    rm /var/cache/apk/*

# ADD https://w1.fi/releases/wpa_supplicant-$WPA_SUPPLICANT_VERSION.tar.gz /tmp
RUN wget https://w1.fi/releases/wpa_supplicant-$WPA_SUPPLICANT_VERSION.tar.gz -O - | tar -xz
COPY defconfig /eapol/wpa_supplicant-$WPA_SUPPLICANT_VERSION/wpa_supplicant/.config

WORKDIR /eapol/wpa_supplicant-$WPA_SUPPLICANT_VERSION/wpa_supplicant
RUN make eapol_test
RUN mv eapol_test /eapol/


WORKDIR /eapol
COPY rad_eap_test /eapol/
RUN rm -rf /eapol/wpa_supplicant-$WPA_SUPPLICANT_VERSION

# EXPOSE 1812/udp 1813/udp 

# CMD ["radiusd", "-sfxx -l stdout"]
# CMD ["radiusd", "-X"]
