document.addEventListener('turbolinks:load',function(){
  $('.button-like').on('ajax:success', function(e) {
    let div_like = $('.question > .card > .like')
    // console.log(e.detail[2])
    div_like.empty();
    div_like.append(e.detail[2].responseText);
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[2];
      $('.alert').empty()
      $('.alert').html(errors.responseText)
    })
});
