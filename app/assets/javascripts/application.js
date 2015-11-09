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
var bounds;
var polyline = new Array();
var infowindow;
var myLatLng = {lat: 28, lng: 0};
function initMap() {
  map = new google.maps.Map(document.getElementById('map-holder'), {
    center: myLatLng,
    zoom: 3,
    scrollwheel: true,
    streetViewControl: false,
    panControl: false,
    mapTypeControlOptions: {position: google.maps.ControlPosition.TOP_RIGHT},
    zoomControlOptions: {position: google.maps.ControlPosition.RIGHT_TOP},
    styles: [{"featureType":"water","elementType":"all","stylers":[{"hue":"#76aee3"},{"saturation":38},{"lightness":-11},{"visibility":"on"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"hue":"#8dc749"},{"saturation":-47},{"lightness":-17},{"visibility":"on"}]},{"featureType":"poi.park","elementType":"all","stylers":[{"hue":"#c6e3a4"},{"saturation":17},{"lightness":-2},{"visibility":"on"}]},{"featureType":"road.arterial","elementType":"all","stylers":[{"hue":"#cccccc"},{"saturation":-100},{"lightness":13},{"visibility":"on"}]},{"featureType":"administrative.land_parcel","elementType":"all","stylers":[{"hue":"#5f5855"},{"saturation":6},{"lightness":-31},{"visibility":"on"}]},{"featureType":"road.local","elementType":"all","stylers":[{"hue":"#ffffff"},{"saturation":-100},{"lightness":100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"all","stylers":[]}]
  });

  polyline = new google.maps.Polyline({
    geodesic: true,
    map: map
  });

  var contentString ='<h3>Sample Content Yo</h3>'

  infowindow = new google.maps.InfoWindow({
    content: contentString
  });

  //initSearch();
  bounds = new google.maps.LatLngBounds();
}





