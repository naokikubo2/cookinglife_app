// Create the script tag, set the appropriate attributes
var script = document.createElement('script');
script.src = 'https://maps.googleapis.com/maps/api/js?key=' + process.env.GOOGLE_CLOUD_API + '&callback=initMap';
script.defer = true;
var map;
var marker;
// Attach your callback function to the `window` object
window.initMap = function () {
  try {
    const lat = parseFloat(document.getElementById('d_latitude').textContent);
    const lng = parseFloat(document.getElementById('d_longitude').textContent);

    let ps = { lat: lat, lng: lng };
    // geocoderを初期化
    geocoder = new google.maps.Geocoder()
    // JS API is loaded and available
    map = new google.maps.Map(document.getElementById('map'), {
      center: ps,
      zoom: 15,
      navigationControl: false
    });

    marker = new google.maps.Marker({
      position: ps,
      map: map,
    });
  } catch (e) {
    console.log(e.message);
  }
};

// Append the 'script' element to 'head'
document.head.appendChild(script);
