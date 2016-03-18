$(document).on("page:change", function() {
  load_select2_tree();
  load_select2_simple();
  load_select2_hide_search_box();
});

function templateResult(result) {
  if (!result.id) {return result.text;}
  var padding = result.element.attributes[0]["value"] * 10 + 12;
  var status = result.element.attributes[2]["value"];
  if(status == "inactive") return;
  var $result = $("<div class='row"+ result.element.attributes[2]["value"] +"'>" +
    "<div class='col-md-2' style='padding-left: " + padding + "px'>" + result.text.split("|")[0] + "</div>" +
    "<div class='col-md-6' style='padding-left: " + padding + "px'>" + result.text.split("|")[1] + "</div>" +
    "<div class='col-md-4'>" + result.text.split("|")[2] + "</div>" +
    "</div>");
  return $result;
};

function templateSelection(result, container) {
  var text = (result.text == "") ? "" : result.text.split("|")[1];
  return $("<div title ='" + text + "'>" + text + "</div>");
}

function load_select2_tree() {
  $(".select2-tree").select2({
    theme: "bootstrap",
    templateResult: templateResult,
    templateSelection: templateSelection,
    dropdownAutoWidth: "true"
  }).on("select2:open", function () {
    $("span.select2-results").parent().addClass("select2-tree-result-parent");
    $("span.select2-results ul").addClass("select2-tree-result-ul");
  });
}

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
  }).trigger("change");
}
