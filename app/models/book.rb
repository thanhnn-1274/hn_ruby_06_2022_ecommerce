class Book < ApplicationRecord
  BOOK_ATTRS = %i(name description price page_num publisher_name
    quantity category_id author_id image).freeze

  has_many :order_details, dependent: :nullify
  has_many :comments, dependent: :destroy
  has_one_attached :image
  belongs_to :author
  belongs_to :category, optional: true

  validates :name, presence: true,
            length: {maximum: Settings.max_name_book_length}
  validates :price, presence: true,
            numericality: {greater_than: Settings.min_book_price_length,
                           less_than: Settings.max_book_price_length}
  validates :description, presence: true,
            length: {maximum: Settings.max_description_length}
  validates :image,
            content_type: {in: Settings.image_format,
                           message: :wrong_format},
            size: {less_than: Settings.image_size.megabytes,
                   message: :too_big}
  validates :page_num, presence: true,
            numericality: {greater_than_or_equal_to: Settings.min_page,
                           only_integer: true}
  validates :quantity, presence: true,
            numericality: {greater_than_or_equal_to: Settings.min_quantity,
                           only_integer: true}

  scope :view_desc, ->{order view: :desc}
  scope :sort_sold, ->(type){order sold: type}
  scope :asc_name, ->{order name: :asc}
  scope :latest_book, ->{order created_at: :desc}
  scope :sort_price, ->(type){order price: type}
  scope :by_ids, ->(ids){where id: ids}
  scope :search_by_name_description, (lambda do |key|
    where "name LIKE ? or description LIKE ? or id LIKE ?",
          "%#{key}%", "%#{key}%", "%#{key}%"
  end)

  delegate :name, to: :category, prefix: :category, allow_nil: true
  delegate :name, to: :author, prefix: :author, allow_nil: true

  def display_image
    image.variant resize_to_limit: Settings.image_book_admin
  end

  def update_view
    increment!(:view, 1)
  end

  ransacker :created_at, type: :date do
    Arel.sql("date(created_at)")
  end
end
