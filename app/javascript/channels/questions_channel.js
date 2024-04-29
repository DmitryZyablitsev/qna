import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  consumer.subscriptions.create({ channel: "QuestionsChannel" }, {

    received(data) {
      let result = this.createTemplate(data.question);
      $('.question-list').append(result)
    },

    createTemplate(question){
      return `<div class="question-${question.id} card mb-3 mt-3" style="max-width: 18rem">
        <div class="card-header text-center">
          <a data-question-id="${question.id}" href="/questions/${question.id}">${question.title}</a>
        </div>
        <div class="card-body">
          <p class="card-text">${question.body}</p>
        </div>
      </div>`
    }
  });
});
