$(document).on('turbolinks:load', function () {

  function readURL(input) {
    $('#user_img_prev').attr('src', '');

    if (input.files && input.files[0]) {

      var reader = new FileReader();

      // 読み込みが完了したら処理が実行されます
      reader.onload = function (e) {
        //formDataでアップロードされたファイルを開く
        var formData = new FormData();

        //画像プレビューを行う
        $('#user_img_prev').attr('src', e.target.result);

      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  //画像が選択されると発火
  $("#user_img").change(function () {
    readURL(this);
  });
})
