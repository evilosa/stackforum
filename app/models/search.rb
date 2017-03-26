class Search
  TYPES = %w(question answer comment user)

  def self.types
    TYPES
  end

  def self.results(query, scopes, page)
    classes = TYPES & scopes
    classes.map! { |scope| scope.capitalize.constantize }

    if classes.present?
      ThinkingSphinx.search(ThinkingSphinx::Query.escape(query), classes: classes, page: page, per_page: 20)
    end
  end
end