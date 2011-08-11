$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});

$(document).ready(function() {

  $('a[href="#edit"]').live('click', function(event) {
    event.preventDefault();

    var edit_link = $(this);
    edit_link.hide();

    var edit_area = edit_link.parent();
    var val_area = $('<input />').attr('type', 'text');

    var form = $('<form />').append(
      $('<label />').text('New value')
    ).append(val_area).append(
      $('<input />').attr('type', 'submit')
    ).bind('submit', function(event) {
      event.preventDefault();

      var value = val_area.val();
      var value_td = edit_area.prev();

      $.post(window.location.href + '/report_fixes', {'field': edit_area.attr('id'), 'new_value': value}, function(data) {
        form.remove();
        edit_link.show();
        value_td.text(value);
      });

    });

    edit_area.append(form);
  });

});
