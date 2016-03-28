$(document).on("ready", function(){
  if($("#item-list").length > 0){
    load_item_list_data();
    hide_show_field();

    $(".item-list-type").on("change", function(){
      load_item_list_data();
      hide_show_field();
    });
  }
});

function load_item_list_data() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var item_list_type_id = $(".item-list-type option:selected").val();
  $.ajax({
    type: "get",
    dataType: "json",
    data: {item_list_type_id: item_list_type_id},
    url: "/api/item_lists?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      load_select2_item_list(data);
    }
  });
}

function templateResultItemList(result) {
  if (!result.id) {return result.text;}
  var padding = result.depth * 10 + 12;
  var $result = $("<div class='row'>" +
    "<div class='col-md-6' style='padding-left: " + padding + "px'>" + result.text + "</div>" +
    "<div class='col-md-4'>" + result.type + "</div>" +
    "</div>");
  return $result;
};

function load_select2_item_list(data) {
  $(".select2-item-list").empty().select2({
    theme: "bootstrap",
    data: data,
    templateResult: templateResultItemList
  }).on("select2:open", function () {
    $("span.select2-results").parent().addClass("select2-tree-result-parent");
    $("span.select2-results ul").addClass("select2-tree-result-ul");
  });
}

function hide_show_field() {
  hide_field();
  var item_list_type = $(".item-list-type option:selected").text().toLowerCase();
  if(item_list_type == "inventory part") {
    $(".manufacturer").show();
    $(".other-field").show();
  } else if (item_list_type == "non-inventory part") {
    $(".manufacturer").show();
  }
}

function hide_field() {
  $(".manufacturer").hide();
  $(".other-field").hide();
}
