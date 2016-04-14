$(function() {
  $(document).on("change", ".fields:last .grid-cell", function() {
    $(".add_nested_fields").click();
    load_chart_account(".chart-account:last");
    load_selectize_simple(".name:last");
  });
});
