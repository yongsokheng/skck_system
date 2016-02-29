$(function() {
  $(document).on("change", ".fields:last .grid-cell", function() {
    $(".add_nested_fields").click();
    load_select2_tree();
    load_select2_simple();
  });
});
