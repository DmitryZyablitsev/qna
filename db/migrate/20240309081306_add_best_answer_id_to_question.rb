class AddBestAnswerIdToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer, table_name: :answers, null: true
  end
end
