$(document).on("ready", function() {
  if($("#enter-bill").length > 0) {
    $(".item-tab").hide();
    load_chart_account(".fields .chart-account");
    $("#tbl-expense").tableScroll();

    $('.nav-tabs a').click(function (e) {
      e.preventDefault();
      tab = $(this).data("tab");
      if(tab == "1") {
        $(".item-tab").hide();
      }else{
        $(".item-tab").show();
      }
    });
  }

});
