class ToppagesController < ApplicationController
  def index
    @microposts = Review.where(micropost_f: true).order(updated_at: "DESC").page(params[:page]).per(10)
  end
  def what
    
  end
end
