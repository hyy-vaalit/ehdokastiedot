// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {

  $('form').bind('submit', function (event) {
    $(this).find('input:submit').attr('disabled','disabled');
  });

});
