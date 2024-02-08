class AnswersController < ApplicationController
  before_action :authenticate_user!
  def new; end

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to @answer.question, notice: 'The response has been created'
    else
      render 'questions/show'
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
