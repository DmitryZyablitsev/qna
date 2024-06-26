class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy]
  authorize_resource

  after_action :publish_question, only: [:create]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to @question, alert: exception.default_message = 'The action is impossible'
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer)
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title, :body, files: [],
                     links_attributes: %i[name url],
                     reward_attributes: %i[name image]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('QuestionsChannel', { question: @question })
  end
end
