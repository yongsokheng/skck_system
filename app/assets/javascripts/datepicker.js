var datetime_options = {
  format: I18n.t("datepicker.date.format"),
  enableOnReadonly: true,
  orientation: "auto",
  autoclose: true,
  todayBtn: "linked",
  showOnFocus: false
};

$(function() {
  $(document).on("focus", "input.datepicker", function(){
    $(this).datepicker(datetime_options).datepicker("show");
  });
});
