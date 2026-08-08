class Food < ApplicationRecord
  belongs_to :created_by_user, class_name: "User", optional: true
  has_many :food_logs, dependent: :destroy

  enum :source, { manual: 0, database: 1 }, default: :database

  validates :name, presence: true
  validates :serving_size_qty, numericality: { greater_than: 0 }
  validates :serving_size_unit, presence: true
  validates :calories, numericality: { greater_than_or_equal_to: 0 }
  validates :protein_g, :carbs_g, :fat_g, numericality: { greater_than_or_equal_to: 0 }

  scope :search, ->(query) { where("name ILIKE :q OR brand ILIKE :q", q: "%#{query}%") }
end
