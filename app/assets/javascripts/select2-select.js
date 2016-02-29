$(document).on("page:change", function() {
  load_select2_tree();
  load_select2_simple();
  load_select2_hide_search_box();
});

function formatResult(result) {
  if (!result.id) {return result.text;}
  var margin = result.element.attributes[0]["value"] * 10;
  var $result = $("<span style='margin-left: " + margin + "px'>" + result.text + "</span>");
  return $result;
};

function load_select2_tree() {
  $(".select2-tree").select2({
    theme: "bootstrap",
    templateResult: formatResult
  });
}

function load_select2_simple() {
  $(".select2-simple").select2({
    theme: "bootstrap"
  });
}

function load_select2_hide_search_box() {
  $(".select2-hide-search").select2({
    theme: "bootstrap",
    width: "100%",
    minimumResultsForSearch: Infinity
  });
}
