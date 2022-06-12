class ItemsController < ApplicationController
  rescue_from   ActiveRecord::RecordNotFound, with: :throw_not_found_error
  def index
    if params[:user_id]
      user = find_user
      items = user.items
      render json: items, include: :user
    else
      render json: Item.all, include: :user
    end
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item
   else
    render json: {error: "404 Not Found"}, status: :not_found
   end

  end

  def create
    new_item = Item.create(item_params)
    if new_item
      render json: new_item, status: :created
   else
    render json: {error: "Unprocessable entity"}, status: :not_found
   end
  end
  

  private
  def find_user
    User.find(params[:user_id])
  end
  
  def throw_not_found_error(exception)
      render json: {error: "#{exception.model} not found"}, status: :not_found
    end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

end
