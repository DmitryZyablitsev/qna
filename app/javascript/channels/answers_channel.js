import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  let path = $(location).attr('pathname').split('/')

  consumer.subscriptions.create({ channel: "AnswersChannel", question: path[2]}, {
    
    received(data){    
      let result = this.createTemplate(data)
      $('.other_answers').append(result)
    },

    createTemplate(data){
      return `<div class="card mb-3 mt-3" id="answer-${data.answer.id}" style="max-width: 35rem">
        <p> ${data.answer.body}</p>
        <div class="files"></div>
        <div class="links"></div>      
        <div class="like">
          <div class="like-rating">0 Likes</div>
        </div>
      </div>`
    }
  })
})
