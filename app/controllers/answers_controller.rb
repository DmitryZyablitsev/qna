class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy best]
  authorize_resource

  after_action :publish_answer, only: [:create]

  def new; end

  def create
    @answer = @question.answers.build(answer_params)

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    @question.update(best_answer: @answer)
    @answer.author.rewards << @question.reward if @question.reward
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "QuestionsChannel/#{@answer.question_id}", { answer: @answer }
    )
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url]).merge(author_id: current_user.id)
  end
end
