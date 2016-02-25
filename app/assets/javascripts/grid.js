$(document).ready(function() {
  set_select2();
  $(document).on("change", ".fields:last .grid-cell", function() {
    $(".add_nested_fields").click();
    set_select2();
  });
});

function set_select2() {
 $(".grid-select").select2({
  theme: "bootstrap"
 });
}
