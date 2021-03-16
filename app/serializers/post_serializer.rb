# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint
#  category_id :bigint
#
# Indexes
#
#  index_posts_on_author_id    (author_id)
#  index_posts_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (category_id => categories.id)
#
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :category, :author, :published_at

  def category
    object.category.as_json(only: %i[id name])
  end

  def author
    object.author.as_json(only: %i[id name email])
  end

  def published_at
    object.created_at.strftime("%B %d %Y, %l:%M%P")
  end
end
