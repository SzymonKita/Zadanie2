#Utworzenie warstwy roboczej
FROM scratch as etap1

#Dołączenie warstwy bazowej
ADD alpine-minirootfs-3.19.1-x86_64.tar /

#aktualizacja i instalacja niezbędnych komponentów
RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs=20.12.1-r0 \
    npm=10.2.5-r0 && \
    rm -rf /etc/apk/cache

#Zmiana katalogu
WORKDIR /home/node/app

#Kopiowanie plików aplikacji
COPY app.js ./app.js
COPY package.json ./package.json

#Etap 2
FROM node:iron-alpine3.19

#Zainstalowanie potrzebynch komponentów
RUN apk add --update --no-cache curl

#Utworzenie i zmiana folderu
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

#Kopiowanie plików w etapu roboczego
COPY --from=etap1 /home/node/app/app.js ./app.js
COPY --from=etap1 /home/node/app/package.json ./package.json

#Informacje o porcie i autorze pliku
EXPOSE 3000
LABEL org.opencontainers.image.authors="Szymon Kita"

HEALTHCHECK --interval=4s --timeout=20s --start-period=2s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

#Zainstalowanie potrzebych komponentów
RUN npm install
RUN npm install express request-ip geoip-lite

ENTRYPOINT ["node", "app.js"]