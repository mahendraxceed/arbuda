// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

var jQuery = require("jquery");

// import jQuery from "jquery";
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;


import "../stylesheets/application"

require("admin-lte");
import "admin-lte/plugins/jquery-ui/jquery-ui.min"

import "admin-lte/plugins/bootstrap/js/bootstrap.bundle.min"

import "admin-lte/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min"
import "admin-lte/plugins/select2/js/select2"



const trkDatatables = require("trk_datatables")

document.addEventListener("turbolinks:load", () => {
    $('[data-toggle="tooltip"]').tooltip()
    trkDatatables.initialise()
    $('.select2').select2()
    $('[data-toggle="tabajax"]').click(function(e) {
        var $this = $(this),
            loadurl = $this.attr('href'),
            targ = $this.attr('data-target');

        $.get(loadurl, function(data) {
            $(targ).html(data);
        });

        $this.tab('show');
        return false;
    });
})

import "./data_bootstrap_datepicker"

