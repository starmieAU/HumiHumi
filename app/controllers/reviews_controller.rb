class ReviewsController < ApplicationController
  before_action :review_find, only: [:edit, :update]
  before_action :check, only: [:edit,:update]
  
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

  def update
    if @review.update(review_params)
        @review.update(micropost_f: micropost_flag(@review))
        flash[:success] = 'レビューが正常に投稿されました'
        redirect_to @review 
    else
        flash.now[:danger] = 'レビューが投稿されませんでした'
        render :edit
    end
  end

  def show
    @review = Review.find(params[:id])
    @tweet_data = get_tweet_data(@review)
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

  private

  def micropost_flag(review)
    if review.review_10_char == "" && review.review_text == ""
      false
    else
      true
    end
  end
  
  def review_find
    @review = Review.find(params[:id])
  end
  def check
    user_check(@review.user)
  end
  
  def get_tweet_data(review)
    {
      title: "#{review.user.prof_name}さんのレビュー",
      content: ( review.review_10_char == "" ? review.book.title : "【#{review.review_10_char}】"),
      image_url: review.book.image_url
    }
  end
end
