var datetime_options = {
  format: I18n.t("datepicker.date.format"),
  enableOnReadonly: true,
  orientation: "auto",
  autoclose: true,
  todayBtn: "linked",
};

$(document).on("page:update", function() {
  $("input.datepicker").datepicker(datetime_options);
});

function set_datepicker(date) {
  $("input.datepicker").datepicker("setDate", I18n.strftime(date, I18n.t("date.formats.default")));
}
