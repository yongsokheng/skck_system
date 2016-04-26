$(document).on("ready", function(){
  $(document).on("focus", ".grid .selectize-input", function() {
    $(".grid .selectize-input").addClass("unfocus");
    $(this).addClass("focus").removeClass("unfocus");
  });
});
