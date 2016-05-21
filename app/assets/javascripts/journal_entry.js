$(document).on("ready", function(){

  if($("#journal-entry").length > 0) {
    $("#tbl-journal-entry").tableScroll();
    load_chart_account(".fields .chart-account");
    load_selectize_simple(".selectize-simple");
    load_name(".fields .name");
    total_balance_journal();
    set_current_period();
    load_btn_status();
    load_btn_navigate();

    if($(".new-journal").length > 0) {
      $(document).on("change", ".transaction-date", function() {
        load_btn_status();
        load_logbook_data();
      });

      $(document).on("change", ".bank_type", function() {
        load_logbook_data();
      });
    }

    $(document).on("change", ".debit", function() {
      $(this).parent().parent().find(".credit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance_journal();
      delete_row($(this));
    });

    $(document).on("change", ".credit", function() {
      $(this).parent().parent().find(".debit").val("");
      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      total_balance_journal();
      delete_row($(this));
    });

    $(document).on("change", ".chart-account", function() {
      var user_email = $(".api").data("email");
      var user_token = $(".api").data("token");
      var name_selector = $(this).parents(".fields").find(".name");
      var chart_account_selectize = $(this)[0].selectize;
      var name_selectize = name_selector[0].selectize;
      var chart_account_value = chart_account_selectize.getValue();

      if(chart_account_value == "") {
        name_selectize.clearOptions();
      }else{
        var account_type = chart_account_selectize.options[chart_account_value].type_code

        $.ajax({
          type: "get",
          data: {account_type: account_type},
          dataType: "json",
          url: "/api/customer_venders?user_token=" + user_token + "&user_email=" + user_email,
          success: function(data) {
            if(data.length > 0) {
              name_selectize.clearOptions();
              name_selectize.addOption(data);
              name_selectize.addItem(data[0].value);
            }else{
              name_selectize.clearOptions();
            }
          }
        });
      }
    });

    $(document).on("keypress", ".debit, .credit, .statement-ending-balance, .price, .cost", function(event) {
      if ((event.which != 46 || $(this).val().indexOf(".") != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
      }
    });

    $(document).on("click", ".btn-save", function(event) {
      validate_save(event);
    });

    $(document).on("click", ".btn-delete", function(event) {
      event.preventDefault();
      $(".journal-delete-modal").modal("show");
    });

    $(document).on("click", ".btn-close-period", function(event) {
      $(".close-period-modal").modal("show");
    });

    $(".logbook-modal").on("hidden.bs.modal", function (e) {
      $(".logbook-modal").html("");
    })

    $(document).on("change", ".fields:last .form-control", function() {
      $(".add_nested_fields").click();
      load_chart_account(".fields .chart-account:last");
      load_name(".fields .name:last");
    });

    // functions
    function set_msg_valid(event, msg) {
      event.preventDefault();
      $(".error-modal").modal("show");
      $(".invalid-msg").html(msg);
    }

    function validate_save(event) {
      if(is_open_balance()) {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.open_balance_validate"));
      }else if(is_current_period() == false){
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.wrong_period", {period: $(".current-period").text()}));
      }else if($(".log_book").val() == "") {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.log_book_not_blank"));
      }else if(is_journal_transaction_exist() == false) {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.trans_validate"));
      }else if(is_account_balance() == false) {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.balance_validate"));
      }else if(is_chart_account_valid() == false) {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.chart_account_validate"))
      }else if(is_name_valid() == false) {
        set_msg_valid(event, I18n.t("journal_entries.validate_errors.name_validate"));
      }
    }

    function load_logbook_data() {
      var user_email = $(".api").data("email");
      var user_token = $(".api").data("token");
      var transaction_date = $(".transaction-date").val();
      var bank_type_selectize = $(".bank_type")[0].selectize;
      var logbook_selectize = $(".log_book")[0].selectize;
      var bank_type_value = bank_type_selectize.getValue();

      if(bank_type_value == "") {
        logbook_selectize.clearOptions();
      }else{
        var cash_type_id = bank_type_selectize.options[bank_type_value].cash_type
        $.ajax({
          type: "get",
          data: {transaction_date: transaction_date, cash_type_id: cash_type_id},
          dataType: "json",
          url: "/api/log_books?user_token=" + user_token + "&user_email=" + user_email,
          success: function(data) {
            if(data.length > 0) {
              logbook_selectize.clearOptions();
              logbook_selectize.addOption(data);
              logbook_selectize.addItem(data[0].value);
            }else{
              logbook_selectize.clearOptions();
            }
          }
        });
      }
    }
    //end functions
  }
});

function total_balance_journal() {
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

function is_open_balance() {
  var logbook_selectize = $(".log_book")[0].selectize;
  var logbook_value = logbook_selectize.getValue();
  if(logbook_value == "") return false;

  var open_balance = logbook_selectize.options[logbook_value].open_balance
  if(open_balance == true)
    return true;
  return false;
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
    var chart_account_selectize = $(this).find(".chart-account")[0].selectize;
    var chart_account_value = chart_account_selectize.getValue();
    if(chart_account_value == "") return true;
    var selected_account_type_code = chart_account_selectize.options[chart_account_value].type_code
    if($.inArray(selected_account_type_code, account_type_code) > -1
      && $(this).find(".name").val() == "") {
      valid = false;
      return;
    }
  });
  return valid;
}

function is_journal_transaction_exist() {
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

function load_btn_status() {
  if((is_current_period() == false) || is_open_balance()) {
    $(".btn-delete, .btn-save").attr("disabled", true);
  }else{
    $(".btn-delete, .btn-save").attr("disabled", false);
  }
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

function load_chart_account(selector) {
  $(""+selector).selectize({
    onInitialize: function () {
      var s = this;
      this.revertSettings.$children.each(function () {
        $.extend(s.options[this.value], $(this).data());
      });
      s.positionDropdown();
    },
    dropdownParent: "body",
    render: {
      option: function(item, escape) {
        var active = item.active;
        if(active == 0) return "";
        var result = ("<div class='row'>" +
          "<div class='col-md-8'>" + item.text + "</div>" +
          "<div class='col-md-4'>" + item.type + "</div>" +
          "</div>");
          return result;
      },
      item: function(item, escape) {
        return "<div>" + item.text + "</div>";
      },
    }
  });
}

function load_name(selector) {
  $(""+selector).selectize({
    onInitialize: function () {
      var s = this;
      this.revertSettings.$children.each(function () {
        $.extend(s.options[this.value], $(this).data());
      });
      s.positionDropdown();
    },
    dropdownParent: "body",
    render: {
      option: function(item, escape) {
        var state = item.state;
        if(state == "inactive") return "";
        var result = ("<div>" + item.text + "</div>");
        return result;
      }
    }
  });
}
