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
    scrollwheel: false,
    //mapTypeId: google.maps.MapTypeId.SATELLITE

  });
}


var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();


$(document).ready(function () {
	$("#location-query").keyup( function () {
		var text =  $(this).val();
		delay( function () {

			$.ajax({
			  url: "https://search.mapzen.com/v1/autocomplete",
			  method: "GET",
			  dataType: "json",
			  data: {
			    "text": text,
			    "api_key": "search-EEgHGcM",
			    "layers": "course",
			    "sources": "ga",

			  },
			  success: function( data, status, jqxhr ){
			    console.log( "Request received:", data );
			    displayResults (data);
			  },
			  error: function( jqxhr, status, error ){
			    console.log( "Something went wrong!" );
			  },
			});
		}, 250);
	});
});

function displayResults( data ){
  $("#location-query-results").empty();
  data.features.forEach(function(feat){
    var label = feat.properties.label;
    $("#location-query-results").append('<li class="location-query-resultslist">'+label+'</li>');
  });
};

