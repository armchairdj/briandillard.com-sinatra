/*
  Call on a jQuery object to enable or disable any form elements in the collection.

  Pass false and all of the buttons will be disabled.

  Pass true, nothing, or any other value, and all of the elements will be enabled.
*/
(function ($, undefined) {
  $.fn.able = function (enabled) {
    var $fields = this.filter("input,button,select,textarea");

    if (enabled === false) {
      $fields.attr("disabled", "disabled");
    }
    else {
      $fields.removeAttr("disabled");
    }

    return this;
  };
})(jQuery);
