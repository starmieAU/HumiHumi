class BooksController < ApplicationController
  def new
    @keyword = params[:keyword]
    result_books = []
    results = []
    if @keyword.present?
      #@books = Book.new.search_google_books(@keyword)
      2.times do |i|
        results_title = RakutenWebService::Books::Book.search({
          title: @keyword,
          page: i+1
        })
        results_author = RakutenWebService::Books::Book.search({
          author: @keyword,
          page: i+1
        })
        results_title.each {|result| results << result }
        results_author.each {|result| results << result }
      end
      results.each do |result|
        book = Book.find_or_initialize_by(read(result))
        result_books << book
      end
    end
    @books = Kaminari.paginate_array(result_books).page(params[:page]).per(10)
  end
  
  def create
    @book = Book.find_or_initialize_by(isbn_13: params[:isbn_13])

    unless @book.persisted?
      results = RakutenWebService::Books::Book.search(isbn: @book.isbn_13)

      @book = Book.new(read(results.first))
      @book.save
    end
    redirect_back
  end
  def ranking
    
  end
  def show
    @book = Book.find_or_initialize_by(isbn_13: params[:id])
    @tab = params[:tab]
    @tab ||= ""
    @short_reviews = @book.short_reviews.page(params[:page]).per(10)
    @long_reviews = @book.long_reviews.page(params[:page]).per(10)

    unless @book.persisted?
      results = RakutenWebService::Books::Book.search(isbn: params[:id])
      @book = Book.new(read(results.first))
    end
  end
  
  def favorite_users
    @book = Book.find_by(isbn_13: params[:id])
    @users = @book.favorite_users.page(params[:page])
    @text = '「私の三冊」に登録しているユーザー'
    render 'users/index'
  end
  
  def shelf_users
    @book = Book.find_by(isbn_13: params[:id])
    @users = @book.shelf_users.page(params[:page])
    @text = '本棚に登録しているユーザー'
    render 'users/index'
  end
  
end
