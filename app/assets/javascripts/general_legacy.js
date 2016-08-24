
/**************************************************************************************************************
 * Legacy (Do not add new changes below, refactor instead)
 **************************************************************************************************************/

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});

$(document).ready(function () {

  $('form').bind('submit', function (event) {
    $(this).find('input:submit').attr('disabled','disabled');
  });

});
