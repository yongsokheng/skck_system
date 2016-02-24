$(document).on("page:change", function(){
  hide_show_statement_ending();

  $(".chart-account-type").select2({
    theme: "bootstrap"
  });

  if($(".chat-of-accounts-form").length > 0){
    chart_of_account_parent_data();
  }

  $(document).on("change", ".chart-account-type", function(){
    hide_show_statement_ending();
  });
});

var hide_show_statement_ending = function(){
  var list = ["ar", "ap", "income",
    "cogs", "expense", "other_income", "other_expense"]
  var val = $(".chart-account-type option:selected").data("acc-code");
  if($.inArray(val, list) >= 0){
    $(".statement_ending").hide();
  }else{
    $(".statement_ending").show();
  }
}

var chart_of_account_parent_data = function(){
  var chart_of_account = $(".chart-of-account")
  var chart_of_account_parents = chart_of_account.data("chart-of-account-parent");
  var parent_id = chart_of_account.data("parent-id");
  $(".chart-of-account-parent").select2({
    theme: "bootstrap",
    data: chart_of_account_parents,
    templateResult: formatResult
  }).select2("val", parent_id);

  function formatResult (result) {
    if (!result.id) { return result.text; }
    var $result = $(
      "<span style='margin-left: " + result.depth * 10 + "px'>" + result.text + "</span>"
    );
    return $result;
  };
}
