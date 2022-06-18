/* Active Admin JS */
$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

  $('a[href="#toggle_filter"]').click(function(event) {
    event.preventDefault();
    $('#sidebar').toggle();
  });

});








/**************************************************************************************************************
 * Legacy (Do not add new changes below, refactor instead)
 **************************************************************************************************************/

$(document).ready(function() {
  if ($('body').hasClass('admin_candidates')) {
    // Some hardcore candidate action!

    $('#candidate_candidate_name').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val().trim();
      var firstname = format_firstname($('#candidate_firstname').val()).trim();
      var candidate_name_input = $(this);
      if (!candidate_name_input.val()) {
        candidate_name_input.val(lastname + ', ' + firstname);
      }
    });

    $('#candidate_email').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val().toLowerCase().trim();
      var firstname = format_firstname($('#candidate_firstname').val().toLowerCase()).trim();
      var candidate_email_input = $(this);
      if (!candidate_email_input.val()) {
        candidate_email_input.val(firstname + '.' + lastname + '@helsinki.fi');
      }
    });

    select_correct_alliance_and_hide_if_set();
  }
});

function format_firstname(firstname) {
  return firstname.split(' ')[0];
}

function select_correct_alliance_and_hide_if_set() {
  alliance_id = $.cookie('alliance');
  if (alliance_id) {
    $('select#candidate_electoral_alliance_id').val(alliance_id).parent().hide();
  }
}
