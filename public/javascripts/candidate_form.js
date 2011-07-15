$(document).ready(function(){
  if ($('body').hasClass('admin_candidates') && ($('body').hasClass('new') || $('body').hasClass('edit'))) {
    // Some hardcore candidate action!

    $('#candidate_candidate_name').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val();
      var firstname = $('#candidate_firstname').val();
      var candidate_name_input = $(this);
      if (!candidate_name_input.val()) {
        candidate_name_input.val(lastname + ', ' + firstname);
      }
    });

    $('#candidate_email').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val().toLowerCase();
      var firstname = $('#candidate_firstname').val().toLowerCase();
      var candidate_email_input = $(this);
      if (!candidate_email_input.val()) {
        candidate_email_input.val(firstname + '.' + lastname + '@helsinki.fi');
      }
    });

  }
});

