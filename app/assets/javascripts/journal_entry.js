$(document).ready(function() {

  total_balance();
  load_name_status();

  $(document).on("change", ".debit", function() {
    $(this).parent().parent().find(".credit").val("");
    if($(this).val() != "")
      $(this).val($.number($(this).val(), 2));
    total_balance();
  });

  $(document).on("change", ".credit", function() {
    $(this).parent().parent().find(".debit").val("");
    if($(this).val() != "")
      $(this).val($.number($(this).val(), 2));
    total_balance();
  });

  $(document).on("change", ".chart-account", function() {
    var account_type_code = ["ar", "ap"];
    var selected_account_type_code = $(this).find("option:selected").attr("data-account-type-code");
    var name = $(this).parents(".fields").find(".name");

    if($.inArray(selected_account_type_code, account_type_code) > -1 || $(this).val() == "") {
      name.attr("disabled", false);
    } else {
      name.select2("val", "");
      name.attr("disabled", true);
    }
  });

  $(document).on("keypress", ".debit, .credit, .statement-ending-balance", function(event) {
    if ((event.which != 46 || $(this).val().indexOf(".") != -1) && (event.which < 48 || event.which > 57)) {
      event.preventDefault();
    }
  });

  $(document).on("click", ".btn-save", function(event) {
    validate_save(event);
  });
});

function total_balance() {
  var total_debit = 0;
  var total_credit = 0;

  $(".fields").each(function() {
    var debit =  $(this).find(".debit").val().replace(/,/g, "");
    var credit = $(this).find(".credit").val().replace(/,/g, "");
    if( debit != "")
      total_debit += parseFloat(debit);
    else if( credit != "")
      total_credit += parseFloat(credit);
  });

  $(".total-debit").html(""+ $.number(total_debit, 2));
  $(".total-credit").html(""+ $.number(total_credit, 2));
}

function set_msg_valid(event, msg) {
  event.preventDefault();
  $(".journal-modal").modal("show");
  $(".invalid-msg").html(msg);
}

function validate_save(event) {
  if(is_transaction_exist() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.trans_validate"));
  }else if(is_account_balance() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.balance_validate"));
  }else if(is_chart_account_valid() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.chart_account_validate"))
  }else if(is_name_valid() == false) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.name_validate"));
  }
}

function is_account_balance() {
  if(parseFloat($(".total-debit").text()) - parseFloat($(".total-credit").text()) == 0)
    return true;
  return false;
}

function is_chart_account_valid() {
  var valid = true;
  $(".fields").each(function() {
    if(($(this).find(".debit").val() != "" || $(this).find(".credit").val() != "")
      && $(this).find(".chart-account").val() == "") {
      valid = false;
      return;
    }
  });
  return valid;
}

function is_name_valid() {
  var valid = true;
  var account_type_code = ["ar", "ap"];
  $(".fields").each(function() {
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("data-account-type-code");
    if($.inArray(selected_account_type_code, account_type_code) > -1
      && $(this).find(".name").val() == "") {
      valid = false;
      return;
    }
  });
  return valid;
}

function is_transaction_exist() {
  var exist = false;
  $(".fields").each(function() {
    if(($(this).find(".debit").val() != "") || ($(this).find(".credit").val() != "")) {
      exist = true;
      return;
    }
  });
  return exist;
}

function load_name_status() {
  var account_type_code = ["ar", "ap"];
  $(".fields").each(function() {
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("data-account-type-code");
    if($.inArray(selected_account_type_code, account_type_code) < 0 &&
      $(this).find(".chart-account").val() != "") {
        $(this).find(".name").select2("val", "");
        $(this).find(".name").attr("disabled", true);
    }
  });
}
