class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def mark_as_edited
    update(edited_at: DateTime.now)
  end
end
