class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @shelves = @user.shelf_relations.page(params[:page]).per(10)
  end
  
  def edit
  end
  
  def update
  end
  
end
