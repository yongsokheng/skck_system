$(document).on("ready", function(){
  if($("#chart-of-account").length > 0) {
    var hide_show_statement_ending = function(){
      var list = ["ar", "ap", "income", "cogs", "expense", "other_income", "other_expense"]
      var chart_account_type = $(".chart-account-type")[0].selectize;
      var val = chart_account_type.options[chart_account_type.getValue()].acc_code
      if($.inArray(val, list) >= 0){
        $(".statement_ending").hide();
      }else{
        $(".statement_ending").show();
      }
    };

    load_selectize_simple(".chart-account-type");
    hide_show_statement_ending();

    $(document).on("change", ".chart-account-type", function(){
      hide_show_statement_ending();
    });
  }
});


