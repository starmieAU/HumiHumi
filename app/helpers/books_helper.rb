module BooksHelper
  def book_counts(book)
    {
      shelf_count: book.shelf_relations.count,
      favorite_count: book.favorite_relations.count,
      short_count: book.short_reviews.count,
      long_count: book.long_reviews.count,
    }
  end
  def average_point(book)
    book.shelf_relations.where.not(point: 0).average(:point)
  end
end
