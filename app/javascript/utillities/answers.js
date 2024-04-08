document.addEventListener('turbolinks:load',function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('d-none');
  })

  $('#form-answer').on('ajax:success', function(e) {
    let answer = e.detail[0];

    $('.other_answers').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0];
      $('.answer-errors').append('<p>' + 'error(s) detected:' + '</p>');
      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })
    })
});
