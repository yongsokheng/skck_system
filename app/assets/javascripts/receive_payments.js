$(document).on("ready", function() {
  if($("#receive-payment").length > 0) {
    load_selectize_simple(".customer");
    load_account_payment(".chart-account");
    load_selectize_simple(".bank_type");
    load_selectize_simple(".log_book");
    $(".tbl-payment").tableScroll();
    total_amount_payment();
    set_btn_status();
    load_btn_navigate();

    $(document).on("change", ".customer", function() {
      var customer_id = $(".customer option:selected").val();
      var transaction_date = $(".transaction-date").val();
      var chart_account = $(".chart-account option:selected").val();
      var bank_type = $(".bank_type option:selected").val();
      var log_book = $(".log_book option:selected").val();
      $.getScript("/receive_payments/new?customer_id=" + customer_id
        +"&transaction_date=" + transaction_date
        +"&chart_account=" + chart_account
        +"&bank_type=" + bank_type
        +"&log_book=" + log_book);
    });

    $(document).on("change", ".transaction-date", function() {
      set_btn_status();
      load_logbook_data();
    });

    $(document).on("change", ".bank_type", function() {
      load_logbook_data();
    });

    $(document).on("click", ".btn-paid", function(event) {
      var fields = $(this).parents(".fields");
      var amt_due = fields.find(".amt-due").text();
      var payment = fields.find(".payment");
      payment.val(amt_due);
    });

    $(document).on("change", ".payment", function(event) {
      var payment_amount = 0;
      $(".fields").each(function() {
        payment_amount += parseFloat($(this).find(".payment").val().replace(/,/g, ""));
      });
      $(".payment-foot").html(""+ $.number(payment_amount, 2));

      if($(this).val() != "")
        $(this).val($.number($(this).val(), 2));
      else
        $(this).val($.number(0, 2));

      var current_payment = parseFloat($(this).val().replace(/,/g, ""));
      var current_amt_due = parseFloat($(this).parents(".fields").find(".amt-due").text().replace(/,/g, ""))
      if(current_payment > current_amt_due) {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.wrong_payment"));
        $(this).val($.number(0, 2));
      }
    });

    $(document).on("keypress", ".payment", function(event) {
      if ((event.which != 46 || $(this).val().indexOf(".") != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
      }
    });

    $(document).on("click", ".btn-save", function(event) {
      validate_save(event);
    });

    $(document).on("click", ".btn-delete", function(event) {
      event.preventDefault();
      $(".payment-delete-modal").modal("show");
    });

    function validate_save(event) {
      if($(".customer").val() == "") {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.customer_blank"));
      }else if($(".chart-account").val() == "") {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.account_blank"));
      }else if($(".bank_type").val() == "") {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.bank_type_blank"));
      }else if($(".log_book").val() == "") {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.log_book_blank"));
      }else if(is_current_period() == false) {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.wrong_period"));
      }else if(is_payment_transaction_exist() == false) {
        set_msg_valid(event, I18n.t("receive_payments.validate_errors.trans_validate"));
      }
    }

    function set_msg_valid(event, msg) {
      event.preventDefault();
      $(".error-modal").modal("show");
      $(".invalid-msg").html(msg);
    }

    function is_payment_transaction_exist() {
      var exist = false;
      $(".fields").each(function() {
        var payment = parseFloat($(this).find(".payment").val().replace(/,/g, ""));
        if(payment > 0) {
          exist = true;
          return;
        }
      });
      return exist;
    }

  }
});

function total_amount_payment() {
  var origin_amount = 0;
  var amount_due = 0;
  var payment_amount = 0;
  $(".fields").each(function() {
    origin_amount += parseFloat($(this).find(".orig-amt").text().replace(/,/g, ""));
    amount_due += parseFloat($(this).find(".amt-due").text().replace(/,/g, ""));
    payment_amount += parseFloat($(this).find(".payment").text().replace(/,/g, ""));
  });
  $(".customer-balance").html(""+ $.number(amount_due, 2));
  $(".orig-amt-foot").html(""+ $.number(origin_amount, 2));
  $(".amt-due-foot").html(""+ $.number(amount_due, 2));
  $(".payment-foot").html(""+ $.number(payment_amount, 2));
}

function load_account_payment(selector) {
  $(""+selector).selectize({
    onInitialize: function () {
      var s = this;
      this.revertSettings.$children.each(function () {
        $.extend(s.options[this.value], $(this).data());
      });
      s.positionDropdown();
    },
    render: {
      option: function(item, escape) {
        var active = item.active;
        if(active == 0) return "";
        var result = ("<div class='row'>" +
          "<div class='col-md-6'>" + item.text + "</div>" +
          "<div class='col-md-6'>" + item.type + "</div>" +
          "</div>");
          return result;
      },
      item: function(item, escape) {
        return "<div>" + item.text + "</div>";
      },
    }
  });
}
