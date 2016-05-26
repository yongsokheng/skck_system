$(document).on("ready", function(){
  var journal_entry = $("#journal-entry").length;
  var invoice = $("#create-invoice").length;
  var receive_payment = $("#receive-payment").length;
  if(journal_entry > 0 ||  invoice > 0 || receive_payment > 0) {

    $(document).on("click", ".pagination a", function() {
      $.getScript(this.href);
      return false;
    });

    $(document).on("click", ".btn-prev", function() {
      if($(this).is('[disabled=disabled]')) {
        event.preventDefault();
      }else{
        $(".icon-loading").show();
        $(".pagination .previous_page a").trigger("click");
      }
    });

    $(document).on("click", ".btn-next", function() {
      if($(this).is('[disabled=disabled]')) {
        event.preventDefault();
      }else{
        $(".icon-loading").show();
        $(".pagination .next_page a").trigger("click");
      }
    });
  }
});

function load_btn_navigate() {
  if($(".pagination").length == 0) {
    $(".btn-prev").attr("disabled", true);
    $(".btn-next").attr("disabled", true);
  }else{
    if($(".pagination .previous_page").hasClass("disabled")) {
      $(".btn-prev").attr("disabled", true);
    }else{
      $(".btn-prev").attr("disabled", false);
    }

    if($(".pagination .next_page").hasClass("disabled")) {
      $(".btn-next").attr("disabled", true);
    }else{
      $(".btn-next").attr("disabled", false);
    }
  }
}
