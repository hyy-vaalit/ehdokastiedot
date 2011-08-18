$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});

$(document).ready(function () {

  $('form').bind('submit', function (event) {
    $(this).find('input:submit').attr('disabled','disabled');
  });

  $('a[href="#accept"]').live('click', acceptFix);
  $('a[href="#reject"]').live('click', rejectFix);

});

function acceptFix(event) {
  event.preventDefault();
  actFix('accept', this);
}

function rejectFix(event) {
  event.preventDefault();
  actFix('reject', this);
}

function actFix(method, element) {
  row = $(element).parent().parent();
  id = (row.attr('id')).replace('fix_','');
  $.post(window.location.href, {'method': method, 'fix_id': id}, function(data) {
    row.remove();
  });
}
