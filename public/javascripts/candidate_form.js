$(document).ready(function(){
  if ($('body').hasClass('admin_candidates') && ($('body').hasClass('new') || $('body').hasClass('edit'))) {
    // Some hardcore candidate action!

    $('#candidate_candidate_name').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val();
      var firstname = $('#candidate_firstname').val();
      var candidate_name_input = $(this);
      var value = candidate_name_input.val();
      if (value == "") {
        candidate_name_input.val(lastname + ', ' + firstname);
      }
    });

  }
});

