class UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :userdash, :manage_orders]
  before_action :current_user?, only: [:edit, :userdash, :manage_orders]

  def index
    if User.find_by(id: session[:user_id])
      @users = User.all
    else
      @users = User.where(merchant: true)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  end

  def show
      @user = User.find_by(id: params[:id])
      # If @user is nil, then the status should be :missing

      if @user == nil
        flash[:error] = "No such user exists!"
        redirect_to users_path
      end
  end

  def edit
    unless current_user?
      redirect_to root_path, :alert => "Members Only"
    end
  end

  def update

    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:success] = "Successfully updated, you go Glen Coco! \u{1F389}"
    else
      render :edit, status: :bad_request
    end
  end

  def userdash
    if current_user?
      @products = @logged_in_user.products
      @orders = @logged_in_user.orders
    else
      redirect_to root_path, :alert => "Members Only"
    end
  end

  def manage_orders
    if current_user?
      if @logged_in_user.merchant == true
        @orders = @logged_in_user.merchant_orders
        entries = []
        my_products = @logged_in_user.products.ids
        @orders.each do |order|
          order.cart_entries.each do |entry|
            if my_products.include?(entry.product_id)
              entries << entry
            end
          end
        end

        if params[:status] == ""
          @title = "all_orders"
        elsif params[:status]
          @title = params[:status]
        else
          @title = "all_orders"
        end

        if params[:status] == "pending"
          @entries = entries.find_all {|entry| entry.status == "paid"}.reverse
        elsif params[:status] == "shipped"
          @entries = entries.find_all {|entry| entry.status == "shipped"}.reverse
        else
          @entries = entries.reverse
        end
      else
        redirect_to root_path, :alert => "Dealers only..."
      end
    else
      redirect_to root_path, :alert => "Members Only"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :username, :email, :merchant, :store_name, :store_banner_img, :store_location, :store_description, :bio)
  end

  def find_user
    @user = User.find_by(id: session[:user_id])
    if @user == nil
      @user = :GUEST
    end
  end

  def current_user?
    @user == User.find_by(id: session[:user_id])
  end
end
