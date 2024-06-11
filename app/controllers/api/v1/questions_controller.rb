class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :find_question, only: %i[show answers update destroy]
  
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show    
    render json: @question, serializer: QuestionSerializer
  end

  def answers
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def create
    question = current_resource_owner.questions.build(question_params)

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy])
  end

end
