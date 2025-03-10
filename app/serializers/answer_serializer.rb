class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id body author_id created_at updated_at]

  has_many :comments
  has_many :links
  has_many :files

  def files
    object.files.map do |file|
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end
  end
end
