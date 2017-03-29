class Search
  #TYPES = %w(question answer comment user)
  TYPES = [Question, Answer, Comment, User].freeze

  def self.types
    TYPES
  end

  def self.results(query, scope, page)
    classes = if scope == 'all'
                TYPES
              else
                [scope.capitalize.constantize]
              end

    if classes.present?
      ThinkingSphinx.search(ThinkingSphinx::Query.escape(query), classes: classes, page: page, per_page: 5)
    end
  end
end