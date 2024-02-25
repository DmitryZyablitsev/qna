class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy]

  def new; end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.save
  end

  def update    
    # @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
    else
      redirect_to question_path(@answer.question), alert: 'You cannot delete this answer'
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
 
  def answer_params
    params.require(:answer).permit(:body).merge(author_id: current_user.id)
  end
end
