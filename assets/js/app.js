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

$(() => {
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
});