//Dołączenie potrzebnych bibliotek
const express = require('express');
const requestIp = require('request-ip');
const geoip = require('geoip-lite');

const port = 3000

const app = express();
 app.get('/', (req, res) => {
    //Pozyskanie informacji o strefie czasowej i godzinie na podstawie IP klienta
    const ip = requestIp.getClientIp(req);
    const geo = geoip.lookup(ip);
    if(geo){
        const date = new Date();
        const time = date.toLocaleString('pl-PL', {timeZone: geo.timezone});

        res.send(`Adres ip: ${ip} <br/> Data i godzina strefy czasowej: ${time}`);
    }else{
        res.send(`Adres ip: ${ip} <br/> Nie udało się określić strefy czasowej`);
    }
 })

app.listen(port, () => `Serwer działa na porcie ${port}`);