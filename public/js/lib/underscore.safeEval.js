/*
  Transform a dot-delimited string into an object reference or undefined.
*/

(function ($, undefined) {
  _.mixin({

    safeEval: function (props, context) {
      var prop, obj;

      /* Attempt to create an array */
      if (typeof props === "string") {
        props = $.makeArray(props.split("."));
      }

      /* If it's still not an array, exit early - bad 'props' argument. */
      if (!this.isArray(props)) {
        return;/* undefined */
      }

      context = context || window;
      prop    = props.shift();
      obj     = context[prop];

      /* Found it! */
      if (props.length === 0) {
        return obj;
      }

      /* Can't keep going so return early */
      if (typeof obj === "undefined") {
        return;/* undefined */
      }

      /* Keep looking recursively */
      return this.safeEval(props, obj);
    }

  });
})(jQuery);
