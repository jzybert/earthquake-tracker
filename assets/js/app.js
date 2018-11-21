// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";
import _ from 'lodash';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import socket from "./socket";

$(function() {
  var map;
  var data = [];

  /*
  * Used to pass in the intitial data to be used.
  * Note: call this function on page load.
  */
  function initData(input) {
    data = input;
  }

  /*
  * Used to find the correct zoom level based on the distances
  * between all epicenters.
  */
  function getZoom(locations) {
    if(locations.length <= 1) {
      return 3;
    }
    // calculate the correct zoom.
    // 1. calculate all of the distances between the earthquakes, in miles.
    var distances = [];
    var temp_locations = locations.slice();
    _.each(locations, (loc1) => {
      temp_locations.shift();
      _.each(temp_locations, (loc2) => {
        distances.push(haversine(loc1, loc2));
      });
    });
    // 2. pick the biggest one.
    var biggestDist = _.max(distances);
    // 3. return the right zoom level based on the the biggest distance.
    if(biggestDist < 60) { //90
      return 10;
    } else if (biggestDist < 120) { //180
      return 9;
    } else if (biggestDist < 240) { //380
      return 8;
    } else if (biggestDist < 470) { //780
      return 7;
    } else if (biggestDist < 950) { //1520
      return 6;
    } else if (biggestDist < 1800) { //3000
      return 5;
    } else if (biggestDist < 3600) { //6000
      return 4;
    }
    return 3;
  }

  /*
  * Used to find the distance between two locations on earth.
  */
  function haversine(a, b) {
    var earth_radius = 6371e3; // meters
    var lat_a = a.lat * (Math.PI / 180);
    var lat_b = b.lat * (Math.PI / 180);
    var lat_diff = (b.lat - a.lat) * (Math.PI / 180);
    var lng_diff = (b.lng - a.lng) * (Math.PI / 180);

    var calc_1 = Math.sin(lat_diff/2) * Math.sin(lat_diff/2) +
                 Math.cos(lat_a) * Math.cos(lat_b) *
                 Math.sin(lng_diff/2) * Math.sin(lng_diff/2);
    var calc_2 = 2 * Math.atan2(Math.sqrt(calc_1), Math.sqrt(1 - calc_1));

    var answer = earth_radius * calc_2;
    return answer * 0.00062137; //convert to miles
  }

  /*
  * Used to intitiate the map.
  * Info:
  *   epicenter: {lat: float, lng: float}
  *   magnitude: Integer
  */
  function initMap(earthquakes) {
    if(earthquakes == undefined || earthquakes.length == 0) {
      map = new google.maps.Map($('#map')[0], {
        center: {
          lat: 0,
          lng: 0
        },
        zoom: 3
      });
    }
    else {
      var mean_center = {
        lat: _.meanBy(earthquakes, function(eq) { return eq.epicenter.lat; }),
        lng: _.meanBy(earthquakes, function(eq) { return eq.epicenter.lng; })
      }

      var zoom = getZoom(_.map(earthquakes, 'epicenter'));

      map = new google.maps.Map($('#map')[0], {
        center: mean_center,
        zoom: zoom
      });

      for(var eq in earthquakes) {
        var marker = new google.maps.Marker({
          title: earthquakes[eq].magnitude,
          position: earthquakes[eq].epicenter,
          map: map
        });
        var circle = new google.maps.Circle({
          strokeColor: '#000000',
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: '#FF0000',
          fillOpacity: 0.35,
          map: map,
          center: earthquakes[eq].epicenter,
          radius: 12 * Math.pow(4, earthquakes[eq].magnitude) //TODO: these numbers need to be tweak to better represent the magnitude of an earthquake.
        });
      }
    }
  }

  $('#size-select').change(ev => {
    let selectedValue = $('#size-select').find(":selected")[0].value;
    if (selectedValue === 'circle') {
      $('#circle-selected').css('display', 'flex');
      $('#square-selected').css('display', 'none');
    } else if (selectedValue === 'square') {
      $('#circle-selected').css('display', 'none');
      $('#square-selected').css('display', 'flex');
    } else {
      $('#circle-selected').css('display', 'none');
      $('#square-selected').css('display', 'none');
    }
  });

  $(document).ready(function() {
    initMap(data);
  });
});

/*
example data:
[
  {
    epicenter: {
      lat: 20.40,
      lng: 30.00
    },
    magnitude: 4
  },
  {
    epicenter: {
      lat: 24.30,
      lng: 31.512
    },
    magnitude: 8
  }
]
*/
