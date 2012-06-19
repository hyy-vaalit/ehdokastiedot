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
