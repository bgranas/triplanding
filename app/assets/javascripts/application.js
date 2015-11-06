// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery.countdown.js
//= require colorbox-rails
//= require jquery.readyselector
//= require turbolinks
//= require_tree .


var map;
var myLatLng = {lat: 28, lng: 0};
function initMap() {
  map = new google.maps.Map(document.getElementById('map-holder'), {
    center: myLatLng,
    zoom: 3,
    scrollwheel: true,
    streetViewControl: false,
    panControl: false,
    mapTypeControlOptions: {position: google.maps.ControlPosition.TOP_RIGHT},
    zoomControlOptions: {position: google.maps.ControlPosition.RIGHT_TOP}
  });
}


var autocomplete;
function initSearch() {
  autocomplete = new google.maps.places.Autocomplete(
    (document.getElementById('location-query')),
      { types: ['geocode'] });
  autocomplete.addListener('place_changed');
}

function geolocate() {
if (navigator.geolocation) {
  navigator.geolocation.getCurrentPosition(function(position) {
    var geolocation = {
      lat: position.coords.latitude,
      lng: position.coords.longitude
    };
    var circle = new google.maps.Circle({
      center: geolocation,
      radius: position.coords.accuracy
    });
    autocomplete.setBounds(circle.getBounds());
  });
}
}



var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();



