$(document).on("ready", function(){

  if($("#journal-entry").length > 0) {
    var old_cash_type_id;
    var old_date;

    load_select2_tree();
    load_select2_customer_vender();
    load_select2_simple();
    total_balance();
    load_name_status();
    set_current_period();
    load_btn_status();

    $(document).on("change", ".debit", function() {
      $(this).parent().parent().find(".credit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance();
      delete_row($(this));
    });

    $(document).on("change", ".credit", function() {
      $(this).parent().parent().find(".debit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance();
      delete_row($(this));
    });

    $(document).on("change", ".chart-account", function() {
      var account_type_code = ["ar", "ap"];
      var selected_account_type_code = $(this).find("option:selected").attr("type");
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

    $(document).on("click", ".btn-delete", function(event) {
      $(".journal-delete-modal").modal("show");
    });

    $(document).on("click", ".btn-close-period", function(event) {
      $(".close-period-modal").modal("show");
    });

    $(document).on("show", ".transaction-date", function(e) {
      old_date = $(this).val();
    });

    $(document).on("hide", ".transaction-date", function(e) {
      var new_date = $(this).val();
      if(old_date !== new_date) {
        load_logbook_data();
      }
    });

    $(document).on("select2:open", ".bank_type", function(event) {
      old_cash_type_id = $(this).find("option:selected").attr("data-cash-type-id");
    });

    $(document).on("change", ".bank_type", function() {
      var new_cash_type_id = $(this).find("option:selected").attr("data-cash-type-id");
      var value = $(".log_book").attr("selected-value");
      if((old_cash_type_id != new_cash_type_id) || value) {
        load_logbook_data();
      }else{
        load_journal_entry();
      }
    });

    $(document).on("change", ".log_book", function() {
      load_journal_entry();
    });

    $(document).on("click", ".btn-prev", function() {
      var transaction_date = new Date($(".transaction-date").val());
      transaction_date.setDate(transaction_date.getDate() - 1);
      set_datepicker(transaction_date);
      load_logbook_data();
    });

    $(document).on("click", ".btn-next", function() {
      var transaction_date = new Date($(".transaction-date").val());
      transaction_date.setDate(transaction_date.getDate() + 1);
      set_datepicker(transaction_date);
      load_logbook_data();
    });
  }
});

$(document).on("page:update", function() {
    if($("#journal-entry").length > 0) {
      load_select2_hide_search_box();
    }
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
  if($(".log_book option:selected").attr("open-balance") == "true") {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.open_balance_validate"));
  }else if(is_current_period() == false){
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.wrong_period", {period: $(".current-period").text()}));
  }else if($(".log_book").val() == null) {
    set_msg_valid(event, I18n.t("journal_entries.validate_errors.log_book_not_blank"));
  }else if(is_transaction_exist() == false) {
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
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("type");
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

function is_current_period() {
  var transaction_date = new Date($(".transaction-date").val());
  var current_start_date = new Date($(".working-period").attr("data-start-date"));
  var current_end_date = new Date($(".working-period").attr("data-end-date"));

  if(transaction_date >= current_start_date && transaction_date <= current_end_date)
    return true;
  return false;
}

function set_current_period() {
  var current_start_date = $(".working-period").attr("data-start-date");
  var current_end_date = $(".working-period").attr("data-end-date");
  $(".current-period").html(current_start_date + " to " + current_end_date + "")
}

function load_name_status() {
  var account_type_code = ["ar", "ap"];
  $(".fields").each(function() {
    var selected_account_type_code = $(this).find(".chart-account option:selected").attr("type");
    if($.inArray(selected_account_type_code, account_type_code) < 0 &&
      $(this).find(".chart-account").val() != "") {
        $(this).find(".name").select2("val", "");
        $(this).find(".name").attr("disabled", true);
    }
  });
}

function load_btn_status() {
  if((is_current_period() == false) ||
    ($(".log_book option:selected").attr("open-balance") == "true")) {
    $(".btn-delete, .btn-save").attr("disabled", true);
  }else if(is_transaction_exist() == false){
    $(".btn-delete").attr("disabled", true);
    $(".btn-save").attr("disabled", false);
  }else{
    $(".btn-delete, .btn-save").attr("disabled", false);
  }
}

function load_logbook_data() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var transaction_date = $(".transaction-date").val();
  var cash_type_id = $(".bank_type option:selected").attr("data-cash-type-id");
  $.ajax({
    type: "get",
    data: {transaction_date: transaction_date, cash_type_id: cash_type_id},
    dataType: "json",
    url: "/api/log_books?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      load_select2_with_data(data);
      set_log_book_val();
    }
  });
}

function reset_journal_transaction_list() {
  $("#tbl-journal-entry").find("tbody").empty();
  for(var i = 0; i < 10; i++) {
    $(".add_nested_fields").click();
  }

  load_select2_tree();
  load_select2_simple();
  load_select2_customer_vender();
  load_btn_status();

  $(".total-debit").html(""+ $.number(0, 2));
  $(".total-credit").html(""+ $.number(0, 2));
  $(".icon-loading").hide();
  $(".form-journal").attr("action", "/journal_entries");
  $(".form-journal input[name='_method']").val("post");
}

function load_journal_entry() {
  var user_email = $(".api").data("email");
  var user_token = $(".api").data("token");
  var log_book_id = $(".log_book").val();
  var bank_type_id = $(".bank_type").val();
  var transaction_date = $(".transaction-date").val();
  var cash_type_id = $(".bank_type option:selected").attr("data-cash-type-id");

  $(".icon-loading").show();

  $.ajax({
    type: "get",
    data: {log_book_id: log_book_id, bank_type_id: bank_type_id},
    dataType: "json",
    url: "/api/journal_entries?user_token=" + user_token + "&user_email=" + user_email,
    success: function(data) {
      if(data) {
        $.get("/select_journal/"+ transaction_date +"/"+ cash_type_id +"/"+ data.id);
      }else{
        reset_journal_transaction_list();
      }
    }
  });
}

function delete_row(e) {
  var debit = e.parents(".fields").find(".debit").val();
  var credit = e.parents(".fields").find(".credit").val();
  if(debit == "" && credit == "") {
    e.parents(".fields").find("input[type=hidden]").val("1");
  }else {
    e.parents(".fields").find("input[type=hidden]").val("false");
  }
}

function set_log_book_val() {
  var value = $(".log_book").attr("selected-value");
  if(value) {
    $(".log_book").select2("val", value);
    $(".log_book").removeAttr("selected-value");
  }
}

function templateResult(result) {
  if (!result.id) {return result.text;}
  var padding = result.element.attributes[0]["value"] * 10 + 12;
  var status = result.element.attributes[2]["value"];
  if(status == "inactive") return;
  var $result = $("<div class='row'>" +
    "<div class='col-md-3' style='padding-left: " + padding + "px'>" + result.text.split("|")[0] + "</div>" +
    "<div class='col-md-5' style='padding-left: " + padding + "px'>" + result.text.split("|")[1] + "</div>" +
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

function templateResultCustomerVender(result) {
  if (!result.id) {return result.text;}
  var state = result.element.attributes[0]["value"];
  var status = result.element.attributes[1]["value"]
  if(state == "inactive") return;
  var $result = $("<div class='row'>" +
    "<div class='col-md-6'>" + result.text + "</div>" +
    "<div class='col-md-1'>" + status + "</div>" +
    "</div>");
  return $result;
};

function load_select2_customer_vender() {
  $(".select2-customer-vender").select2({
    templateResult: templateResultCustomerVender,
    theme: "bootstrap",
  }).on("select2:open", function () {
    $("span.select2-results").parent().addClass("select2-tree-result-parent-small");
    $("span.select2-results ul").addClass("select2-tree-result-ul");
  });;
}
