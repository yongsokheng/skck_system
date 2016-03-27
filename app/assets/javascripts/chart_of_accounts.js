var parent_id;
var account_id;
$(document).on("page:change", function(){
  if($("#chart-of-account").length > 0) {
    parent_id = $(".parent-id").data("parent-id");
    account_id = $(".account-id").data("account-id");
    hide_show_statement_ending();
    load_chart_account_data();
    disable_account_type();

    $(document).on("change", ".chart-account-type", function(){
      hide_show_statement_ending();
      load_chart_account_data();
    });
  }
});

function load_chart_account_data() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var chart_account_type = $(".chart-account-type option:selected").val();

  $.ajax({
    type: "get",
    dataType: "json",
    data: {chart_account_type_id: chart_account_type},
    url: "/api/chart_of_accounts?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      chart_of_accounts_select2(data);
    }
  });
}

var chart_of_accounts_select2 = function(data) {
  $(".chart-of-account-tree").empty().select2({
    theme: "bootstrap",
    data: data,
    templateResult: ChartAccountTemplateResult,
    templateSelection: ChartAccounTemplateSelection,
    dropdownAutoWidth: "true"
  })
  .on("select2:open", function () {
    $("span.select2-results").parent().addClass("select2-tree-result-parent");
    $("span.select2-results ul").addClass("select2-tree-result-ul");
  }).select2("val", parent_id);
}

function ChartAccountTemplateResult(result) {
  if (!result.id) {return result.text;}
  var padding = result.depth * 20 + 20;
  if((result.id == account_id) || ((result.status == "inactive") && (result.id != parent_id))) return;
  var $result = $("<div class='row'>" +
    "<div class='col-md-4' style='padding-left: " + padding + "px'>" + result.no + "</div>" +
    "<div class='col-md-4' style='padding-left: " + padding + "px'>" + result.text + "</div>" +
    "<div class='col-md-4'>" + result.type + "</div>" +
    "</div>");
  return $result;
}

function ChartAccounTemplateSelection(result, container) {
  var text = result.text;
  return $("<div title ='" + text + "'>" + text + "</div>");
}

var hide_show_statement_ending = function(){
  var list = ["ar", "ap", "income", "cogs", "expense", "other_income", "other_expense"]
  var val = $(".chart-account-type option:selected").data("acc-code");
  if($.inArray(val, list) >= 0){
    $(".statement_ending").hide();
  }else{
    $(".statement_ending").show();
  }
};

var disable_account_type = function() {
  var type = $(".account-type").data("account-type");
  var disable_type = ["ar", "ap"]
  if($.inArray(type, disable_type) >= 0) {
    $(".chart-account-type").prop("disabled", true);
  } else if(!type == "") {
    var option = $(".chart-account-type option")
    $.each(option, function(){
      if($.inArray($(this).data("acc-code"), disable_type) >= 0) {
        $(this).prop("disabled", true);
      }
    });
  }
}
