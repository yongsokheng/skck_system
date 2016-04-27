$(document).on("ready", function() {
  if($("#create-invoice").length > 0) {
    $("#tbl-invoice").tableScroll();
    load_selectize_simple(".customer");
    load_selectize_simple(".term");
    load_um(".fields .unit-of-measure");
    load_item_list(".fields .item-list");
    load_invoice_amount();
    load_btn_navigate();

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
      var item_list_selectize = $(this)[0].selectize;
      var data_um_id = item_list_selectize.options[item_list_selectize.getValue()].um_id;
      var data_price = item_list_selectize.options[item_list_selectize.getValue()].price;

      unit_of_measure_selectize.addItem(data_um_id);
      price_each.val($.number(data_price, 2)).trigger("change");
    });

    $(document).on("change", ".quantity, .price-each", function() {
      var parent = $(this).parent().parent();
      var quantity = parent.find(".quantity");
      var price_each = parent.find(".price-each");
      var amount = parent.find(".amount");
      var price_each_num = 0;

      if(price_each.val() != "") {
        price_each.val($.number(price_each.val(), 2));
        price_each_num = parseFloat(price_each.val().replace(/,/g, ""));
      }

      var quantity_num = quantity.val() == "" ? 1 : parseFloat(quantity.val());
      var amount_num = quantity_num * price_each_num;
      amount.val($.number(amount_num, 2));
      total_balance_invoice();
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
      $(".invoice-delete-modal").modal("show");
    });

    //functions

    function validate_save(event) {
      if($(".customer").val() == "") {
        set_msg_valid(event, I18n.t("create_invoice.validate_errors.customer_blank"));
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
      var price_each_num = price_each.val() == "" ? 0 : parseFloat(price_each.val().replace(/,/g, ""));
      var quantity_num = quantity.val() == "" ? 1 : parseFloat(quantity.val());
      var amount_num = quantity_num * price_each_num;
      amount.val($.number(amount_num, 2));
    }

    if( amount.val() != "") {
      total += parseFloat(amount.val().replace(/,/g, ""));
    }
    $(".total").html(""+ $.number(total, 2));
  });
}

function total_balance_invoice() {
  var total = 0;

  $(".fields").each(function() {
    var amount =  $(this).find(".amount").val();
    if( amount != "") {
      total += parseFloat(amount.replace(/,/g, ""));
    }
  });

  $(".total").html(""+ $.number(total, 2));
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
        var status = item.status;
        if(status == "inactive") return "";
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
