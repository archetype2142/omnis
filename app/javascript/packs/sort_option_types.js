import Sortable from 'sortablejs';

var el = document.getElementById('option_types');
var sortable = Sortable.create(el, {
  onEnd: function (evt) {
    var order = Array.prototype.map.call(evt.to.childNodes, function( el, i ) {
      return el.id;
    });
    el.parentNode.submit();
    // location.reload();
  }
});
