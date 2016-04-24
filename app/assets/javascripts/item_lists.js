$(document).on("ready", function(){
  if($("#item-list").length > 0){

    load_selectize_simple(".item-list-type");
    load_selectize_simple(".chart-of-account");
    load_selectize_simple(".customer-vender");
    load_selectize_simple(".unit-of-measure");

    hide_show_field();

    $(".item-list-type").on("change", function(){
      hide_show_field();
    });

    function hide_show_field() {
      hide_field();
      var item_list_type = $(".item-list-type option:selected").text().toLowerCase();
      if(item_list_type == "inventory part") {
        $(".manufacturer").show();
        $(".other-field").show();
        $(".price").show();
      } else if (item_list_type == "non-inventory part") {
        $(".manufacturer").show();
      } else if (item_list_type == "service") {
        $(".price").show();
      }
    }

    function hide_field() {
      $(".manufacturer").hide();
      $(".other-field").hide();
      $(".price").hide();
    }
  }
});
