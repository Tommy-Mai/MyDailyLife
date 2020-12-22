$(document).on('turbolinks:load', function(){
  // ここからお問い合わせ作成モーダル
  $('#contact_btn').on('click',function(){
    $('.js-modal_inquiry').fadeIn();
    return false;
  });
  $('.js-modal-close_inquiry').on('click',function(){
    $('.js-modal_inquiry').fadeOut();
    return false;
  });
  // ここまでお問い合わせモーダル
});
