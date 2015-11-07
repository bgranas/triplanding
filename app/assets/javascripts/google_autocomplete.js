var autocomplete;
var place;


function initSearch() {
  autocomplete = new google.maps.places.Autocomplete(
    (document.getElementById('location-query')),
      { types: ['geocode'] });
  autocomplete.addListener('place_changed', function(){
    place = autocomplete.getPlace();
  });
}


/*Asks user for their current position to increase accuracy of results */
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
