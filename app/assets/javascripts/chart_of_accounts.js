$(document).on("page:change", function(){
  if($("#chart-of-account").length > 0) {
    hide_show_statement_ending();

    $(document).on("change", ".chart-account-type", function(){
      hide_show_statement_ending();
    });
  }
});

var hide_show_statement_ending = function(){
  var list = ["ar", "ap", "income", "cogs", "expense", "other_income", "other_expense"]
  var val = $(".chart-account-type option:selected").data("acc-code");
  if($.inArray(val, list) >= 0){
    $(".statement_ending").hide();
  }else{
    $(".statement_ending").show();
  }
}
