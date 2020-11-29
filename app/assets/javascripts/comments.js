// const { data } = require("jquery");

$(document).on('turbolinks:load', function(){
  // ここから文字列内のURLをリンクタグに変換する機能
  function AutoLink(str) {
    var regexp_url = /((h?)(ttps?:\/\/[a-zA-Z0-9.\-_@:/~?%&;=+#',()*!]+))/g; // ']))/;
    var regexp_makeLink = function(all, url, h, href) {
        return '<a href="h' + href + '" target="_blank">' + url + '</a>';
    }
    return str.replace(regexp_url, regexp_makeLink);
  };
  // ここまで文字列内のURLをリンクタグに変換する機能

  // ここからコメント新規作成Ajax
  function createHTML(content) {
    var CreatedAt = new Date(content.created_at);
    var Hours = CreatedAt.getHours();
    var Minutes = (CreatedAt.getMinutes()<10?'0':'') + CreatedAt.getMinutes();

    var link = AutoLink(content.comment)
    var text = link.replace( /\r?\n/g, '<br />' );

    let html = `<div class="right_block" id="comment${content.id}">
                  <div class="right_comment_block">
                    <div class="right_balloon baloon_comment">
                      ${text}
                    </div>
                  </div>
                  <div class="right_item_block">
                    <div class="comment_destroy_right">
                      <a href="">
                        <i class="fas fa-trash-alt"></i>
                      </a>
                    </div>
                    <div class="comment_time_right">
                      ${Hours}:${Minutes}
                    </div>
                  </div>
                </div>`
    return html;
  };

  function createImage(content) {
    var CreatedAt = new Date(content.created_at);
    var Hours = CreatedAt.getHours();
    var Minutes = (CreatedAt.getMinutes()<10?'0':'') + CreatedAt.getMinutes();
    let imageSrc = `<div class="left_block">
                      <div class="left_balloon image_ballon">
                        <img src="${content.image}">
                      </div>
                      <div class="left_item_block">
                        <div class="comment_time_left">
                          ${Hours}:${Minutes}
                        </div>
                        <div class="comment_destroy_left">
                          <a data-confirm="コメントを削除します。" data-remote="true" rel="nofollow" data-method="delete" href="/meal_comments/2">
                            <i class="fas fa-trash-alt"></i>
                          </a>
                        </div>
                      </div>
                    </div>`
    return imageSrc;
  }

  $('.fa-image').on("click", function(){
    $('#comment_image').trigger("click")
  });

  var selectFile;
  $('#comment_image').on('change',function(){
    console.log("upload file");
    if (Object.keys(this.files).length > 0) {
      selectFile = this.files[0];
    }
  });

  $('#comment-form').on("submit", function(e) {
    console.log("btn,submitted")
    e.preventDefault();
    let inputId = $('#current_task_id').val();
    let inputText = $('#comment_text').val();
    console.log(inputText)

    if (inputText) {
      console.log("text post");
      $.ajax({
        url: "/meal_comments",
        type: "POST",
        data: {
          comment: inputText,
          task_id: inputId
        },
        dataType: "json"
      })
      .done(function(data) {
        $('#comment_text').val("");
        let html = createHTML(data);
        $(".comment-container").append(html);
        $(".comment-container").scrollTop($(".comment-container")[0].scrollHeight);
      })
      .fail(function(data, textStatus, jqXHR){
        console.log(data);
        console.log(textStatus);
        console.log(jqXHR);
        alert("エラー：コメントを登録できませんでした。\n・空白のコメントは登録できません。\n・141文字以上のタグは登録できません。");
      })
      .always(function() {
        $(".comment_form_btn input").prop('disabled', false);
      });
    };

    if ($(selectFile).length) {
      console.log("image post");
      console.log(selectFile);
      console.log($.type(selectFile));
      console.log(inputId);

      var filetype = selectFile["type"];
      console.log(filetype)
    
      // Blobを生成する
      var blob = new Blob([selectFile], {type: filetype});
      console.log(blob);

      var formData = new FormData();
      formData.append('task_id', inputId);
      formData.append('image', blob);
      $.ajax({
        url: "/meal_comments",
        type: "POST",
        data: formData,
        dataType: "json",
        processData: false,
        contentType: false
      })
      .done(function(data) {
        let imageBallon = createImage(data);
        $(".comment-container").append(imageBallon);
        selectFile = [];
        console.log(selectFile);
        $(".comment-container").scrollTop($(".comment-container")[0].scrollHeight);
      })
      .fail(function(data, textStatus, jqXHR){
        console.log(data);
        console.log(textStatus);
        console.log(jqXHR);
        alert("エラー：コメントを登録できませんでした。\n・空白のコメントは登録できません。\n・141文字以上のタグは登録できません。");
      })
      .always(function() {
        $(".comment_form_btn input").prop('disabled', false);
      });
    };
  });
  // ここまでコメント新規作成Ajax

  
    var Uploader = {
      upload: function(imageFile){
        var def =$.Deferred();
        var formData = new FormData();
        formData.append('image', imageFile);
        $.ajax({
          type: "POST",
          url: "/meal_comments/upload_image",
          data: formData,
          dataType: 'json',
          processData: false,
          contentType: false,
          success: def.resolve
        })
        return def.promise();
      }
    };

    // $('.fa-image').on("click", function(){
    //   $('#comment_image').trigger("click")
    // });
  
    // $('#comment_image').on('change',function(e){
    //   var files = e.target.files;
    //   var d = (new $.Deferred()).resolve();
    //   $.each(files,function(i,file){
    //     d = d.then(function() {
    //         return Uploader.upload(file)})
    //       .then(function(data){
    //         return previewImage(file, data.image);
    //     });
    //   });
    //   $('#item_images').val('');
    // });
  
    // var Uploader = {
    //   upload: function(imageFile){
    //     var def =$.Deferred();
    //     var formData = new FormData();
    //     formData.append('image', imageFile);
    //     $.ajax({
    //       type: "POST",
    //       url: "/meal_comments/upload_image",
    //       data: formData,
    //       dataType: 'json',
    //       processData: false,
    //       contentType: false,
    //       success: def.resolve
    //     })
    //     return def.promise();
    //   }
    // };
});

