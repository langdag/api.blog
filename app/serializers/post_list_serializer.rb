class PostListSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :category, :published_at
  
    def category
      object.category.as_json(only: %i[id name])
    end
  
    def published_at
      object.created_at.strftime('%c')
    end

    def content
      object.content.length < 500 ? object.content : object.content[0..500] + '...'
    end
end