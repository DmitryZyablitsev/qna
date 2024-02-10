class AnswersController < ApplicationController
  before_action :authenticate_user!
  def new; end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer[:question_id] = params['question_id']

    if @answer.save
      redirect_to @answer.question, notice: 'The response has been created'
    else
      render 'questions/show'
    end
  end

  def destroy
    @question_id = params['question_id']
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(@question_id), notice: 'Answer was successfully deleted'
    else
      redirect_to question_path(@question_id), alert: 'You cannot delete this answer'
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
