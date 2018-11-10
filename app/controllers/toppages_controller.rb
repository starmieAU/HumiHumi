class ToppagesController < ApplicationController
  def index
    @microposts = Review.where.not(review_10_char: "",review_text: "").page(params[:page]).per(10)
  end
end
