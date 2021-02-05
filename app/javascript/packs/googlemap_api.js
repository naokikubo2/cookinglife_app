// Create the script tag, set the appropriate attributes
var script = document.createElement('script');
script.src = 'https://maps.googleapis.com/maps/api/js?key=' + process.env.GOOGLE_CLOUD_API + '&callback=initMap';
script.defer = true;
var map;
var marker;
let geocoder
// Attach your callback function to the `window` object
window.initMap = function () {
  try {
    var lat = 35.6432274;
    var lng = 139.7400553;
    if (document.getElementById('latitude').value != "") {
      lat = parseFloat(document.getElementById('latitude').value);
      lng = parseFloat(document.getElementById('longitude').value);
    } else {
      //Userの住所が正しく入力されていない場合
      document.getElementById('flag_address').textContent = "ユーザーの住所がマップに反映できませんでした。登録された住所に誤りがある可能性があります。";
    }


    let ps = { lat: lat, lng: lng };
    // geocoderを初期化
    geocoder = new google.maps.Geocoder()
    // JS API is loaded and available
    map = new google.maps.Map(document.getElementById('map'), {
      center: ps,
      zoom: 15
    });

    marker = new google.maps.Marker({
      position: ps,
      map: map,
    });

    google.maps.event.addListener(map, 'click', event => clickListener(event, map));
  } catch (e) {
    console.log(e.message);
  }
};

function clickListener(event, map) {
  const lat = event.latLng.lat();
  const lng = event.latLng.lng();
  //既にあるマーカーを一旦削除
  deleteMakers();
  marker = new google.maps.Marker({
    position: { lat, lng },
    map
  });
  const input_lat = document.getElementById("latitude");
  const input_lng = document.getElementById("longitude");
  input_lat.value = lat;
  input_lng.value = lng;
  //input.style.visibility = "visible";
}
function deleteMakers() {
  if (marker != null) {
    marker.setMap(null);
  }
  marker = null;
}

document.getElementById("search_codeAddress").onclick = function () {
  // 入力を取得
  let inputAddress = document.getElementById('address').value;

  // geocodingしたあとmapを移動
  geocoder.geocode({ 'address': inputAddress }, function (results, status) {
    if (status == 'OK') {
      // map.setCenterで地図が移動
      map.setCenter(results[0].geometry.location);
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
};


// Append the 'script' element to 'head'
document.head.appendChild(script);
