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

  $('a[href="#machinedraw"]').live('click', machinedraw);

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

function machinedraw(event) {
  event.preventDefault();

  //+ Jonas Raoni Soares Silva
  //@ http://jsfromhell.com/array/shuffle [v1.0]
  shuffle = function(o){ //v1.0
    for(var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
  };

  text_fields = $(this).parent().parent().find('input[type="text"]');
  count = text_fields.length;
  values = [];
  for(var i=1; i <= count; i++) {
    values.push(i)
  }
  values = shuffle(values)
  $.each(text_fields, function(i, field) {
    value = values.pop();
    $(field).val(value);
  });
}
