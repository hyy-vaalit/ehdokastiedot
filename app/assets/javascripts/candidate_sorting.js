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
