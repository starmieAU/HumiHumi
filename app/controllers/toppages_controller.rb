class ToppagesController < ApplicationController
  def index
    @microposts = Review.where(micropost_f: true).page(params[:page]).per(10)
  end
end
