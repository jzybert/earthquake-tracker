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
import 'phoenix_html'
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import 'bootstrap';
import _ from 'lodash';
import moment from 'moment';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import socket from './socket';

let data = window.eq_data ? window.eq_data : [];

console.log(data);

$(() => {
  let map;

  /*
  * Used to pass in the initial data to be used.
  * Note: call this function on page load.
  */
  function initData(input) {
    data = _.map(input, (eq) => {
      return {
        place: eq.place,
        time: moment(eq.time).format('llll'),
        epicenter: {
          lat: eq.latitude,
          lng: eq.longitude
        },
        magnitude: eq.mag,
        depth: eq.depth
      };
    })
  }

  /*
  * Used to find the correct zoom level based on the distances
  * between all epicenters.
  */
  function getZoom(locations) {
    if (locations.length <= 1) {
      return 3;
    }
    // calculate the correct zoom.
    // 1. calculate all of the distances between the earthquakes, in miles.
    let distances = [];
    let temp_locations = locations.slice();
    _.each(locations, (loc1) => {
      temp_locations.shift();
      _.each(temp_locations, (loc2) => {
        distances.push(haversine(loc1, loc2));
      });
    });
    // 2. pick the biggest one.
    let biggestDist = _.max(distances);
    // 3. return the right zoom level based on the the biggest distance.
    if (biggestDist < 60) { //90
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
    let earth_radius = 6371e3; // meters
    let lat_a = a.lat * (Math.PI / 180);
    let lat_b = b.lat * (Math.PI / 180);
    let lat_diff = (b.lat - a.lat) * (Math.PI / 180);
    let lng_diff = (b.lng - a.lng) * (Math.PI / 180);

    let calc_1 = Math.sin(lat_diff/2) * Math.sin(lat_diff/2) +
                 Math.cos(lat_a) * Math.cos(lat_b) *
                 Math.sin(lng_diff/2) * Math.sin(lng_diff/2);
    let calc_2 = 2 * Math.atan2(Math.sqrt(calc_1), Math.sqrt(1 - calc_1));

    let answer = earth_radius * calc_2;
    return answer * 0.00062137; //convert to miles
  }

  /*
  * Used to initialize the map.
  * Info:
  *   epicenter: {lat: float, lng: float}
  *   magnitude: Integer
  */
  function initMap(earthquakes) {
    if (earthquakes === undefined || earthquakes.length === 0) {
      map = new google.maps.Map($('#map')[0], {
        center: {
          lat: 0,
          lng: 0
        },
        zoom: 3
      });
    }
    else {
      let mean_center = {
        lat: _.meanBy(earthquakes, function(eq) { return eq.epicenter.lat; }),
        lng: _.meanBy(earthquakes, function(eq) { return eq.epicenter.lng; })
      };

      let zoom = getZoom(_.map(earthquakes, 'epicenter'));

      map = new google.maps.Map($('#map')[0], {
        center: mean_center,
        zoom: zoom
      });

      for (let eq in earthquakes) {
        let infowindow = new google.maps.InfoWindow({
          content: '<div class="row">' +
            '<div class="col-12">' +
            '<h3>'+ earthquakes[eq].place +'</h3>' +
            '<p><b>When:</b> '+ earthquakes[eq].time +'</p>' +
            '<p><b>Magnitude:</b> '+ earthquakes[eq].magnitude +'</p>' +
            '<p><b>Depth:</b> '+ earthquakes[eq].depth +'</p>' +
            '<p><b>Latitude:</b> '+ earthquakes[eq].epicenter.lat +'</p>' +
            '<p><b>Longitude:</b> '+ earthquakes[eq].epicenter.lng +'</p>' +
            '</div>' +
            '</div>'
        });
        let marker = new google.maps.Marker({
          title: earthquakes[eq].magnitude.toString(),
          position: earthquakes[eq].epicenter,
          map: map
        });
        marker.addListener('click', function() {
          infowindow.open(map, marker);
        });
        let circle = new google.maps.Circle({
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

  // this stuff is only necessary for the news page.
  if (window.location.pathname == "/news") {
    let news_channel = socket.channel('news:lobby', {});
    let page = 1;

    function handleEvent(type, payload) {
      let list = $('#news-container');
      let articles = [];
      for (var key in payload) {
        articles = payload[key];
      }
      if(type == "shout") {
        list.empty();
      }
      _.each(articles, (article) => {
        article = JSON.parse(article);
        list.append("<div class=\"card\">" +
          "<div class=\"card-body\">" +
            "<h4>"+ article.title +"</h4>" +
            "<div class=\"row\">" +
              "<div class=\"col-3\">" +
                "<img src=\""+ article.url_to_image +"\" class=\"img-fluid\"/>" +
              "</div>" +
              "<div class=\"col-9\">" +
                "<p><b>From:</b> "+ article.source +" | "+ article.published_at +"</p>" +
                "<hr />" +
                "<p><b>Description:</b> "+ article.description +"</p>" +
                "<p><b>Full story:</b> <a href=\""+ article.url +"\">"+ article.url +"</a></p>" +
              "</div>" +
            "</div>" +
          "</div>" +
        "</div>");
      });
    }

    news_channel.on('shout', (payload) => {
      console.log("reloading news");
        handleEvent("shout", payload);
    });

    news_channel.on('more', (payload) => {
      console.log("more news");
      handleEvent("more", payload);
    });

    news_channel.join().receive("ok", resp => { console.log("joined News") });

    $('#more-news').click(() => {
      page += 1;
      news_channel.push("more", {page: page});
    });

    // add timer to call "shout" every so often
    setInterval(() => { news_channel.push("shout", {}); }, 1000 * 60 * 15);
  }

  $(document).ready(() => {
    initData(data);
    initMap(data);
  });
});
