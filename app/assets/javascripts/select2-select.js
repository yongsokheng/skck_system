function load_select2_simple() {
  $(".select2-simple").select2({
    theme: "bootstrap",
  });
}

function load_select2_hide_search_box() {
  $(".select2-hide-search").select2({
    theme: "bootstrap",
    width: "100%",
    minimumResultsForSearch: Infinity
  });
}

function load_select2_with_data(data) {
  $(".select2-data").empty().select2({
    theme: "bootstrap",
    data: data
  });
}
