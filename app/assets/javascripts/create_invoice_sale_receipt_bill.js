$(document).on("ready", function() {
  if($("#create-invoice").length > 0 || $("#sale-receipt").length > 0 ||
      $("#enter-bill").length > 0) {
    $("#tbl-transaction").tableScroll();
    load_selectize_simple(".customer");
    load_um(".fields .unit-of-measure");
    load_item_list(".fields .item-list");
    load_selectize_simple(".bank_type");
    load_selectize_simple(".log_book");
    load_account_receivable(".account-receivable");

    if($("#create-invoice").length > 0 || $("#sale-receipt").length > 0) {
      load_invoice_amount();
    }
    load_btn_navigate();
    set_btn_status();

    $(document).on("keypress", ".quantity, .price-each, .amount", function(event) {
      if ((event.which != 46 || $(this).val().indexOf(".") != -1) && (event.which < 48 || event.which > 57)) {
        event.preventDefault();
      }
    });

    $(document).on("change", ".item-list", function() {
      var parent = $(this).parent().parent();
      var unit_of_measure = parent.find(".unit-of-measure");
      var unit_of_measure_selectize = unit_of_measure[0].selectize;
      var price_each = parent.find(".price-each");
      var cost = parent.find(".cost");
      var item_list_selectize = $(this)[0].selectize;

      if($(this).val() !== "") {
        var data_um_id = item_list_selectize.options[item_list_selectize.getValue()].um_id;
        var data_price = item_list_selectize.options[item_list_selectize.getValue()].price;
        var data_cost = item_list_selectize.options[item_list_selectize.getValue()].cost;

        unit_of_measure_selectize.addItem(data_um_id);
        if(price_each.length > 0) {
          price_each.val($.number(data_price, 2)).trigger("change");
        }else{
          cost.val($.number(data_cost, 2)).trigger("change");
        }
      }
    });

    $(document).on("change", ".quantity, .price-each, .cost", function() {
      var parent = $(this).parent().parent();
      var quantity = parent.find(".quantity");
      var price_each = parent.find(".price-each");
      var cost = parent.find(".cost");
      var amount = parent.find(".amount");
      var value = 0;

      if(price_each.length > 0 && price_each.val() != "") {
        price_each.val($.number(price_each.val(), 2));
        value = parseFloat(price_each.val().replace(/,/g, ""));
      }

      if(cost.length > 0 && cost.val() != "") {
        cost.val($.number(cost.val(), 2));
        value = parseFloat(cost.val().replace(/,/g, ""));
      }

      var quantity_num = quantity.val() == "" ? 1 : parseFloat(quantity.val());
      var amount_num = quantity_num * value;
      amount.val($.number(amount_num, 2));

      if($("#create-invoice").length > 0 || $("#sale-receipt").length > 0) {
        $(".total").html(total_balance_for($("#tbl-transaction .fields")));
      }

      if($("#enter-bill").length > 0) {
        $(".total-item").html(total_balance_for($("#tbl-transaction .fields")));
      }
    });

    $(document).on("change", "#tbl-expense .amount", function() {
      if($(this).val() != "") {
        $(this).val($.number($(this).val(), 2));
      }
      $(".total-expense").html(total_balance_for($("#tbl-expense .fields")));
    });

    $(document).on("change", ".fields:last .form-control", function() {
      $(".add_nested_fields").click();
      load_chart_account(".fields .item-list:last");
      load_um(".fields .unit-of-measure:last");
    });

    $(document).on("click", ".btn-save", function(event) {
      validate_save(event);
    });

    $(document).on("click", ".btn-delete", function(event) {
      event.preventDefault();
      $(".invoice-delete-modal").modal("show");
    });

    $(document).on("change", ".transaction-date", function() {
      set_btn_status();
    });

    //functions

    function validate_save(event) {
      if($(".customer").val() == "") {
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.customer_blank"));
      }else if(is_current_period() == false) {
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.wrong_period"));
      }else if($(".account-receivable").val() == "") {
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.account_blank"));
      }else if($(".bank_type").val() == "") {
        set_msg_valid(event, I18n.t("sale_receipt.validate_errors.bank_type_blank"));
      }else if($(".log_book").val() == "") {
        set_msg_valid(event, I18n.t("sale_receipt.validate_errors.log_book_blank"));
      }else if(is_invoice_transaction_exist() == false) {
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.trans_validate"));
      }else if(is_transaction_valid() == false){
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.transaction_valid"));
      }
    }

    function set_msg_valid(event, msg) {
      event.preventDefault();
      $(".error-modal").modal("show");
      $(".invalid-msg").html(msg);
    }

    function is_invoice_transaction_exist() {
      var exist = false;
      $(".fields").each(function() {
        var item_list = $(this).find(".item-list").val();
        var amount = parseFloat($(this).find(".amount").val().replace(/,/g, ""));
        if(item_list != "" && amount >= 0 ) {
          exist = true;
          return;
        }
      });
      return exist;
    }

    function is_transaction_valid() {
      var valid = true;
      $(".fields").each(function() {
        var item_list = $(this).find(".item-list").val();
        var amount = parseFloat($(this).find(".amount").val().replace(/,/g, ""));
        if(item_list == "" && amount > 0) {
          valid = false;
          return;
        }
      });
      return valid;
    }
    //end functions
  }
})

function load_invoice_amount() {
  var total = 0;

  $(".fields").each(function() {
    var quantity =  $(this).find(".quantity");
    var price_each = $(this).find(".price-each");
    var amount = $(this).find(".amount");
    if(quantity.val() !="" || price_each.val() != "") {
      var value = price_each.val() == "" ? 0 : parseFloat(price_each.val().replace(/,/g, ""));
      var quantity_num = quantity.val() == "" ? 1 : parseFloat(quantity.val());
      var amount_num = quantity_num * value;
      amount.val($.number(amount_num, 2));
    }

    if( amount.val() != "") {
      total += parseFloat(amount.val().replace(/,/g, ""));
    }
    $(".total").html(""+ $.number(total, 2));
  });
}

function set_btn_status() {
  if(is_current_period() == false) {
    $(".btn-delete, .btn-save").attr("disabled", true);
  }else{
    $(".btn-delete, .btn-save").attr("disabled", false);
  }
}

function total_balance_for(type_dom) {
  var total = 0;

  type_dom.each(function() {
    var amount =  $(this).find(".amount").val();
    if( amount != "") {
      total += parseFloat(amount.replace(/,/g, ""));
    }
  });
  return "$"+$.number(total, 2);
}

function load_item_list(selector) {
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

function load_um(selector) {
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
        var result = ("<div>" + item.text + "</div>");
        return result;
      },
    }
  });
}

function load_account_receivable(selector) {
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
