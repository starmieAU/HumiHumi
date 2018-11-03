class Book < ApplicationRecord
  require "addressable/uri"
  
  has_many :reviews
  has_many :has_users, through: :reviews, source: :user
  
  def search_books(keyword)
    books = []
    if keyword.present?
      json_books = get_json(keyword)
      json_books["items"].each do |json_book|
        book = Book.new(read(json_book))
        books << book
      end
    end
    books
  end

  def get_json(keyword)
    uri = Addressable::URI.parse("https://www.googleapis.com/books/v1/volumes?q=#{keyword}")
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
    uid = json_book["id"]
    title = json_book["volumeInfo"]["title"]
    subtitle = json_book["volumeInfo"]["subtitle"]
    authors = json_book["volumeInfo"]["authors"].join(' ')
    publisher = json_book["volumeInfo"]["publisher"]
    published_date = json_book["volumeInfo"]["published_date"]
    description = json_book["volumeInfo"]["description"]
    image_url = json_book["volumeInfo"]["imageLinks"]["thumbnail"]
    isbn_10 = json_book["volumeInfo"]["industryIdentifiers"].find { |item| item["type"] == "ISBN_10"} &.fetch("identifier")
    isbn_13 = json_book["volumeInfo"]["industryIdentifiers"].find { |item| item["type"] == "ISBN_13"} &.fetch("identifier")
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
