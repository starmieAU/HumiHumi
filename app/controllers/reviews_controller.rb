class ReviewsController < ApplicationController
  def create
    @book = Book.find_or_initialize_by(isbn_13: params[:isbn_13])

    unless @book.persisted?
      # @book が保存されていない場合、先に @book を保存する
      results = RakutenWebService::Books::Book.search(isbn: @book.isbn_13)

      @book = Book.new(read(results.first))
      @book.save
    end
    if params[:relation] == 'favorite'
      #私の三冊に追加
      current_user.favorite(@book)
      flash[:success] = '「私の三冊」に追加しました。'
    end
    if params[:relation] == 'shelf'
      #本棚に追加
      current_user.shelf(@book)
      flash[:success] = '本棚に追加しました。'
    end
    redirect_back(fallback_location: root_path)
  end

  def new
    @review = Review.new(book_id: params[:book_id])
  end

  def show
    @review = Review.find(params[:id])
  end

  def destroy
    @book = Book.find(params[:book_id])

    if params[:relation] == 'favorite'
      flash[:success] = '「私の三冊」から外しました。'
      current_user.unfavorite(@book) 
    end
    
    if params[:relation] == 'shelf'

      current_user.unshelf(@book) 
      flash[:success] = '本棚から削除、レビューを削除しました。'
    end
    redirect_back(fallback_location: root_path)
  end

  def index
  end

  def edit
  end
  
  private

  def review_params
    params.require(:review).permit(
      :user_id,
      :book_id,
      :favorite,
      :read_status,
      :emotion,
      :point,
      :u_article,
      :u_point,
      :review_10_char,
      :review_text,
      :review_caution,
      :user_memo
    )
  end
end
