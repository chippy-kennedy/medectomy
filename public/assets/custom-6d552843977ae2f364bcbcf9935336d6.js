(function() {
  $(document).ready(function() {
    return $('.protected').bind('contextmenu copy cut', function(e) {
      e.preventDefault();
    });
  });

}).call(this);
