//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .


$(function() {
  var sortableClass          = "sortable";
  var enableSortingElement   = "#enable-sorting";
  var disableSortingElement  = "#disable-sorting";
  var sortableHintClass      = ".sortable-hint";

  function enableSorting(sortableElement) {
    sortableElement.sortable({
      update: function(event, ui) {
        var newPosition = ui.item.index();
        var allianceId  = ui.item.attr("data-alliance-id");
        var candidateId = ui.item.attr("data-candidate-id");
        var scope        = ui.item.attr("data-scope");

        $.ajax({
          type: 'PUT',
          url: urlForCandidate(scope, allianceId, candidateId),
          dataType: 'json',
          data: { candidate: { numbering_order_position: newPosition } },
        });
      }
    });

    sortableElement.disableSelection();
  }

  // e.g. /admin/alliances/12/candidates/43 or /advocates/alliances/12/candidates/43
  function urlForCandidate(scope, allianceId, candidateId) {
    if (scope == "admin") {
      return '/admin/candidates/'+ candidateId;
    } else {
      return '/'+ scope +'/alliances/'+ allianceId +'/candidates/'+ candidateId;
    }
  }

  $( enableSortingElement ).click(function() {
    var triggerElement        = $(enableSortingElement);
    var sortableElement       = $(triggerElement.attr("data-sortable-element"));
    sortableElement.addClass(sortableClass);

    triggerElement.hide();
    $(disableSortingElement).show();
    $(sortableHintClass).show();

    enableSorting(sortableElement);
  }),

  $( disableSortingElement ).click(function() {
    window.location.reload();
  })
});



/**************************************************************************************************************
 * SS Legacy (Do not add new changes below, refactor instead)
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
