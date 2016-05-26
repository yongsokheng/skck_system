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
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require selectize
//= require jquery_nested_form
//= require bootstrap-datepicker
//= require jquery.validate
//= require i18n
//= require i18n/translations
//= require datepicker
//= require selectize_init
//= require jquery-number-format
//= require jquery.tablescroll
//= require grid
//=  require navigation_btn
//= require journal_entry
//= require chart_of_accounts
//= require item_lists
//= require create_invoice
//= require receive_payments

var flash = function() {
  setTimeout(function() {
    $(".hide-flash").fadeOut("normal");
  }, 3000);
}

$(document).on("ready", flash);
$(document).on("page:update", flash);
