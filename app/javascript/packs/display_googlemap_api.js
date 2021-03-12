import { Loader } from '@googlemaps/js-api-loader';
var map;
var marker;

const loader = new Loader({
  apiKey: process.env.GOOGLE_CLOUD_API,
  version: "weekly",
  libraries: ["places"]
});

loader.load().then(() => {
  const lat = parseFloat(document.getElementById('d_latitude').textContent);
  const lng = parseFloat(document.getElementById('d_longitude').textContent);

  let ps = { lat: lat, lng: lng };

  map = new google.maps.Map(document.getElementById("map"), {
    center: ps,
    zoom: 15,
  });

  marker = new google.maps.Marker({
    position: ps,
    map: map,
  });
});
