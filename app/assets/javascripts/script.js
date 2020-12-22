$(document).on('turbolinks:load', function(){
  // ここから検索窓トグル
  $('#searchtoggle_button').on("click",function() {
    $('#searchtoggle_menu').slideToggle();
    if($(this).hasClass('fas fa-search-plus')){
      $(this).removeClass('fas fa-search-plus');
      $(this).addClass('fas fa-search-minus');
    } else {
      $(this).removeClass('fas fa-search-minus');
      $(this).addClass('fas fa-search-plus');
    };
  });
  // ここまで検索窓トグル

  // ここからリンク先案内吹き出し
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

  $('#meal_pop_up').hide();
  
  $('#meal_pop_trigger').hover(function() {
    sethover = setTimeout(function(){
      $('#meal_pop_up').fadeIn();
    },600);
  }, function(){
    $('#meal_pop_up').fadeOut(300);
    clearTimeout(sethover);
  });
  // ここまでリンク先案内吹き出し

  // ここからflash[:notice]を一定時間ごにフェードアウト
  setTimeout(function() {
    $('.time-limit').fadeOut('slow')
  }, 3000);
  // ここまでflash[:notice]を一定時間ごにフェードアウト

  $('.current').attr('id', 'current')
});
