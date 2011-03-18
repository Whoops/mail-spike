whoops = {};

whoops.on_ready = function() {
  $('side').load('folders');
  //  var ajax = new Request.HTML({ update: $('side'),
  //                                url: 'folders'});
};
window.addEvent('domready',whoops.on_ready);
