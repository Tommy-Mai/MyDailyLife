$(document).on('turbolinks:load', function(){
    var mySwiper = new Swiper ('.swiper-container', {
        loop: true,
        SimulateTouch: false,
        shortSwipes: false,
        longSwipes: false,
        autoplay: {
            delay: 4000,
            disableOnInteraction: false
        },
        speed: 2000,
        effect: 'fade',
        fadeEffect: {
            crossFade: true
        },

        on: {
            //スライド切り替え開始時に実行
            transitionStart: function(){

                //以前アクティブだったスライドのインデックス番号を取得する
                var previousIndex = this.previousIndex;
                //取得したインデックス番号を持つスライド要素を取得する
                var previousSlide = document.getElementsByClassName('swiper-slide')[previousIndex];
                //n秒後に「is-play」のクラス属性を削除する
                setTimeout(function() {
                    previousSlide.firstElementChild.classList.remove('is-play');
                }, 2000);
            },

            //スライド切り替え完了後に実行
            transitionEnd: function(){
                //現在アクティブ状態にあるスライドのインデックス番号を取得する
                var activeIndex = this.activeIndex;
                //取得したインデックス番号を持つスライド要素を取得する
                var activeSlide = document.getElementsByClassName('swiper-slide')[activeIndex];
                //スライド要素に「is-play」のクラス属性を追加する
                activeSlide.firstElementChild.classList.add('is-play');
            },
        }
    });
});