document.addEventListener('turbolinks:load',function(){
    $('.form-comment').on('ajax:success', function(e) {
    $('.comment-errors').empty()
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0];
      $('.comment-errors').empty()

      $('.comment-errors').append('<p>' + 'error(s) detected:' + '</p>');
      $.each(errors, function(index, value) {
        $('.comment-errors').append('<p>' + value + '</p>');
      })
    })

});
