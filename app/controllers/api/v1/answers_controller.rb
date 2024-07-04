class Api::V1::AnswersController < Api::V1::BaseController

  before_action :find_answer, only: %i[show update destroy]
  before_action :find_question, only: :create

  authorize_resource

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    answer = @question.answers.build(answer_params)
    answer.author = current_resource_owner
    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    head :ok
  end

  private

  def find_answer
    @answer ||= Answer.find(params[:id])
  end

  def find_question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
