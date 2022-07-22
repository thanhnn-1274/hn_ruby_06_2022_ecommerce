class Comment < ApplicationRecord
  COMMENT_ATTRS = %w(content rate book_id image).freeze
  belongs_to :user
  belongs_to :book

  has_one_attached :image
  validates :content, presence: true,
    length: {minimum: Settings.comment.content_min_length,
             maximum: Settings.comment.content_max_length}
  validates :rate, presence: true
  validates :image, content_type: {in: Settings.user.image.image_path,
                                   message: :wrong_format}

  after_commit :update_rate
  scope :latest_comment, ->{order(created_at: :desc)}
  scope :by_book_id, ->(book_id){where(book_id: book_id)}

  private

  def update_rate
    numerator = book.rate_avg * (book.comments.length - 1) + rate
    denominator = book.comments.length
    new_rate_avg = numerator / denominator
    book.update_columns rate_avg: new_rate_avg
  end
end
