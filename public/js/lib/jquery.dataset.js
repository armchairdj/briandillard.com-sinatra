/*
  Cross-browser support for HTML5 "dataset" API, including:
    * extra methods for setting and removing data-attributes
    * extra filtering methods for retrieving only namespaced data-attributes
*/

(function ($, undefined) {
  var
    BASE_STRING = 'data-',
    HYPHEN_PATTERN = /-([a-z])/g,
    CAMEL_PATTERN = /[A-Z]/g
  ;

  /* regexp replacement helpers */

  function replaceHyphenated(match, lowercase) {
    return lowercase.toUpperCase();
  }

  function replaceCamels(match) {
    return '-' + match.toLowerCase();
  }

  function toCamel(str) {
    return str.replace(HYPHEN_PATTERN, replaceHyphenated);
  }

  function toHyphenated(str) {
    return str.replace(CAMEL_PATTERN, replaceCamels); 
  }

  /* string coerce helpers */

  function attrPrefix(filter) {
    var str = BASE_STRING;

    if (typeof filter ===  'string') {
      str += toHyphenated(filter) + '-';
    }

    return str;
  }

  function attrName(key, filter) {
    return attrPrefix(filter) + toHyphenated(key);
  }

  /* getters */

  function getAttr(node, key, filter) {
    return $(node).attr(attrName(key, filter));
  }

  function getAttrs(node, filter) {
    var i, j, attr, name, attrs = node.attributes, result = {};

    for (i = 0, j = attrs.length; i < j; i++) {
      attr = attrs[i];
      name = attr && attr.name;

      if (name && name.indexOf(filter) === 0) {
        result[ toCamel(name.replace(filter, '')) ] = attr.value;
      }
    }

    return result;
  }

  function dataset(key, filter) {
    /* return an empty hash or undefined if no nodes to inspect */
    if (this.length === 0) {
      return (typeof key === 'string' ? undefined : {});
    }

    /* return a single data- value when passed a key */
    if (typeof key === 'string') {
      return getAttr(this[0], key, filter);
    }

    /* return a hash of all data- values if passed no key */
    return getAttrs(this[0], attrPrefix(filter));
  }

  /* setters */

  function setAttr(node, key, value, filter) {
    return $(node).attr(attrName(key, filter), value);
  }

  function setAttrs(node, hash, filter) {
    var key, $node = $(node);

    for (key in hash) {
      if (hash.hasOwnProperty(key)) {
        setAttr(node, key, hash[key], filter);
      }
    }
  }

  function writeDataset(keyOrHash, valueOrFilter, filter) {
    if (this.length > 0) {
      if ($.isPlainObject(keyOrHash)) {
        /* set data-attributes from a hash */
        setAttrs(this[0], keyOrHash, valueOrFilter);
      }
      else {
        /* set a single data-attribute */
        setAttr(this[0], keyOrHash, valueOrFilter, filter);
      }
    }

    return this;
  }

  /* removers */

  function removeAttr(node, key, filter) {
    return $(node).removeAttr(attrName(key, filter));
  }

  function removeAttrs(node, filter) {
    var i, j, attr, name, attrs = node.attributes, removals = [];

    for (i = 0, j = attrs.length; i < j; i++) {
      attr = attrs[i];
      name = attr && attr.name;

      if (name && name.indexOf(filter) === 0) {
        removals.push(name);
      }
    }

    for (i = 0, j = removals.length; i < j; i++) {
      $(node).removeAttr(removals[i]);
    }
  }

  function removeDataset(key, filter) {
    if (this.length > 0) {
        /* remove a single data-attribute */
      if (typeof key === 'string') {
        removeAttr(this[0], key, filter);
      }
      else {
        /* remove all data-attributes */
        removeAttrs(this[0], attrPrefix(filter));
      }
    }

    return this;
  }

  /*
    NON-CHAINABLE: Always returns undefined, a string, or an object.

    $node.dataset();             # get all data-attributes as a hash
    $node.dataset(null, filter); # get filtered data-attributes as a hash
    $node.dataset(key);          # get 1 data- value as a string
    $node.dataset(key, filter);  # get 1 filtered data- value as a string
  */
  $.fn.dataset = dataset;

  /*
    CHAINABLE: Always returns the jQuery object.

    $node.writeDataset(key, value);          # set 1 data- value
    $node.writeDataset(key, value, filter);  # set 1 namespaced data- value
    $node.writeDataset(hash);                # set 1+ data- values
    $node.writeDataset(hash, filter);        # set 1+ namespaced data- values
  */
  $.fn.writeDataset = writeDataset;

  /*
    CHAINABLE: Always returns the jQuery object.

    $node.removeDataset();             # remove all data-attributes.
    $node.removeDataset(null, filter); # remove multiple namespaced data-attributes.
    $node.removeDataset(key);          # remove 0-1 data-attributes.
    $node.removeDataset(key, filter);  # remove 0-1 namespaced data-attributes.
  */
  $.fn.removeDataset = removeDataset;

})(jQuery);
