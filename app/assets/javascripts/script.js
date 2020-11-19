$(document).on('turbolinks:load', function(){
  $('#pop_up').hide();
  
  $('#pop_trigger').hover(function() {
    sethover = setTimeout(function(){
      $('#pop_up').fadeIn();
    },600);
  }, function(){
    $('#pop_up').fadeOut(300);
    clearTimeout(sethover);
  });

  $('#header_pop').hide();
  
  $('#header_pop_trigger').hover(function() {
    sethover = setTimeout(function(){
      $('#header_pop').fadeIn();
    },600);
  }, function(){
    $('#header_pop').fadeOut(300);
    clearTimeout(sethover);
  });

  $('#other_pop_up').hide();
  
  $('#other_pop_trigger').hover(function() {
    sethover = setTimeout(function(){
      $('#other_pop_up').fadeIn();
    },600);
  }, function(){
    $('#other_pop_up').fadeOut(300);
    clearTimeout(sethover);
  });
});