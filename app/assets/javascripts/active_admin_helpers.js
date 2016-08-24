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
      var lastname = $('#candidate_lastname').val();
      var firstname = format_firstname($('#candidate_firstname').val());
      var candidate_name_input = $(this);
      if (!candidate_name_input.val()) {
        candidate_name_input.val(lastname + ', ' + firstname);
      }
    });

    $('#candidate_email').bind('focusin', function(event) {
      var lastname = $('#candidate_lastname').val().toLowerCase();
      var firstname = format_firstname($('#candidate_firstname').val().toLowerCase());
      var candidate_email_input = $(this);
      if (!candidate_email_input.val()) {
        candidate_email_input.val(firstname + '.' + lastname + '@helsinki.fi');
      }
    });

    $('#candidate_social_security_number').bind('focusout', check_social_security_number);

    select_correct_alliance_and_hide_if_set();

  }
});

function format_firstname(firstname) {
  return firstname.split(' ')[0];
}

function mark_social_security_number_invalid(error) {
  var field =  $('#candidate_social_security_number');
  field.css('border', 'thin solid red'); //FIXME: move to CSS file
  var list_item = field.parent();
  var errorbox = list_item.find('.errorbox');
  if (errorbox.length == 0) {
    errorbox = $('<p class="inline-errors">').addClass('errorbox').text(error);
    list_item.append(errorbox);
  } else {
    errorbox.text(error);
  }
}

function mark_social_security_number_valid() {
  var field =  $('#candidate_social_security_number');
  field.css('border', 'thin solid green'); //FIXME: move to CSS file
  var list_item = field.parent();
  var errorbox = list_item.find('.errorbox');
  if (errorbox.length == 1) {
    errorbox.remove();
  }
}

function calculate_social_security_number_checksum(bday, identifier) {
  var index = (parseInt(bday+identifier, 10) % 31);
  var checksums = "0123456789ABCDEFHJKLMNPRSTUVWXY";
  return checksums[index];
}

function check_social_security_number(event) {
  var input_was = $(this).val();

  if (input_was.length < 11)
    return mark_social_security_number_invalid('too short');
  else if (input_was.length > 11)
    return mark_social_security_number_invalid('too long');

  var x_part = input_was.substring(0, 6);
  var y_part = input_was[6];
  var z_part = input_was.substring(7,10);
  var q_part = input_was[10];

  if (!x_part.match(/^[0-9]+$/))
    return mark_social_security_number_invalid('check b-day');
  else if (!y_part.match(/^[+-A]$/))
    return mark_social_security_number_invalid('check century code');
  else if (!z_part.match(/^[0-9]+$/))
    return mark_social_security_number_invalid('check identifier');

  var checksum = calculate_social_security_number_checksum(x_part, z_part);
  if (checksum != q_part)
    return mark_social_security_number_invalid('checksum should be: ' + checksum);

  mark_social_security_number_valid();
}

function select_correct_alliance_and_hide_if_set() {
  alliance_id = $.cookie('alliance');
  if (alliance_id) {
    $('select#candidate_electoral_alliance_id').val(alliance_id).parent().hide();
  }
}
