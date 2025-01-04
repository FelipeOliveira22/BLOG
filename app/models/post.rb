class Post < ApplicationRecord
  include PgSearch
  extend FriendlyId

  # Validações
  validates :title, :author, :body, presence: true

  # Associações
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  # Friendly ID
  friendly_id :title, use: :slugged

  # Pesquisa
  pg_search_scope :search,
                  against: %i[title author body],
                  associated_against: { comments: %i[body], tags: %i[name] }

  # Atributo virtual para tags
  attr_accessor :tag_names

  # Callbacks
  after_save :assign_tags

  private

  # Método para associar tags ao post
  def assign_tags
    return if tag_names.blank?

    tag_names.split(",").each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)
      self.tags << tag unless self.tags.include?(tag)
    end
  end
end
