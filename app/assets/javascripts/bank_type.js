$(document).on("page:update", function() {
  if($("#bank-types").length > 0) {
    load_select2_hide_search_box();
  }
});
