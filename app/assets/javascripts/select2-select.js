function load_selectize_simple(selector) {
  $(""+selector).selectize({
    onInitialize: function () {
      var s = this;
      this.revertSettings.$children.each(function () {
        $.extend(s.options[this.value], $(this).data());
      });
    }
  });
}
