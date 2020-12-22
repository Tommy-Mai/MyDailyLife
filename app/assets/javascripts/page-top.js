$(document).on('turbolinks:load', function(){
  jQuery(function() {
    var appear = false;
    var pageTop = $('#page-top_btn');
    $(window).on('scroll',function () {
      if ($(this).scrollTop() > 100) {  //100pxスクロールしたら
        if (appear == false) {
          appear = true;
          pageTop.stop().animate({
            'bottom': '2px' //下から50pxの位置に
          }, 300); //0.3秒かけて現れる
        }
      } else {
        if (appear) {
          appear = false;
          pageTop.stop().animate({
            'bottom': '-50px' //下から-50pxの位置に
          }, 300); //0.3秒かけて隠れる
        }
      }
    });
    pageTop.on('click',function () {
      $('body, html').animate({ scrollTop: 0 }, 300); //0.5秒かけてトップへ戻る
      return false;
    });
  });
});