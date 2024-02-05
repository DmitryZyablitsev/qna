class AnswersController < ApplicationController
  def new; end

  def create
    Answer.create(answer_params)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
