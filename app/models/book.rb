class Book < ApplicationRecord
  require "addressable/uri"
  
  has_many :reviews
  has_many :has_users, through: :reviews, source: :user
  
  has_many :favorite_relations, -> { where(favorite: true) }, class_name: 'Review', foreign_key: 'book_id'
  has_many :shelf_relations, -> { where(favorite: false) }, class_name: 'Review', foreign_key: 'book_id'
  #10-str-review
  has_many :short_reviews, -> { where.not(review_10_char: "") }, class_name: 'Review', foreign_key: 'book_id'
  #text-review
  has_many :long_reviews, -> { where.not(review_text: "") }, class_name: 'Review', foreign_key: 'book_id'

  #google books apiで使用 使いにくいので一旦保留
  def search_google_books(keyword)
    books = []
    json_books = get_json(keyword)
    if json_books.present?
      json_books["items"].each do |json_book|
        book = Book.find_or_initialize_by(read(json_book))
        books << book
      end
    end
    books
  end

  def get_json(keyword)
    uri = Addressable::URI.parse("https://www.googleapis.com/books/v1/volumes?q=#{keyword}&maxResults=40&orderBy=relevance")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end
    case response
      when Net::HTTPSuccess
        json = JSON.parse(response.body)
        if json['results_returned'] == 0
          nil
        else
          json
        end
      else
        nil
    end
  end
  
  private
  
  def read(json_book)
    uid = json_book.dig("id")
    title = json_book.dig("volumeInfo", "title")
    subtitle = json_book.dig("volumeInfo","subtitle")
    authors = json_book.dig("volumeInfo","authors")&.join(' ')
    publisher = json_book.dig("volumeInfo","publisher")
    published_date = json_book.dig("volumeInfo","published_date")
    description = json_book.dig("volumeInfo","description")
    image_url = json_book.dig("volumeInfo","imageLinks","thumbnail") || "/images/no_image.png"
    isbn_10 = json_book.dig("volumeInfo","industryIdentifiers")&.find { |item| item["type"] == "ISBN_10"} &.fetch("identifier")
    isbn_13 = json_book.dig("volumeInfo","industryIdentifiers")&.find { |item| item["type"] == "ISBN_13"} &.fetch("identifier")
    {
      uid: uid,
      title: title,
      subtitle: subtitle,
      authors: authors,
      publisher: publisher,
      published_date: published_date,
      description: description,
      image_url: image_url,
      isbn_10: isbn_10,
      isbn_13: isbn_13,
      
    }
  end


end
