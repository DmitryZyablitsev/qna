document.addEventListener('turbolinks:load',function(){
  $('.new-answer').on('click', '.create-answer-link', function(e) {
    e.preventDefault();
    $(this).addClass('d-none');
    $('#form-answer').removeClass('d-none');
    $('.roll-up-answer-form').removeClass('d-none');
  })

  $('.new-answer').on('click', '.roll-up-answer-form', function(e) {
    e.preventDefault();
    $(this).addClass('d-none');
    $('#form-answer').addClass('d-none');
    $('.create-answer-link').removeClass('d-none');
  })
});
