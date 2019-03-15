class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @user_stocks = current_user.stocks
  end

  def my_friends
    @friendships = current_user.friends
  end

  def search
    # grab the parameter of the search, find the user and store it in a
    # instance variable --> go to user model to define search()
    # @users = User.search(params[:search_param])
    # render a json at user
    # render json: @users
    # grab the search code from search stock and make it useable for friends
    if params[:search_param].blank?
      flash.now[:danger] = "You entered a blank statement "
    else
      @users = User.search(params[:search_param])
      @users = current_user.except_current_user(@users)
      flash.now[:danger] = "The user you are looking for does not exist" if @users.blank?
    end
    respond_to do |format|
      format.js {render partial: 'friends/result'}
    end
  end

  def add_friend
    # grab a instance variable friend
    @friend = current_user.friendships.where(friend_id: params[:friend])
    # build the friendship association
    current_user.friendships.build(friend_id: params[:friend])
    # if you are able to sabe the friendship association
    if current_user.save

      # friend was succesfully added
      flash[:success]= "Succesfully added as friend"
      redirect_to my_friends_path

    else
      # there was something wrong with the friend request
      flash[:notice] = "Something went wrong"
      # redirecto to the page that show the search bar and the friends list
      redirect_to my_friends_path
    end
    #----------------------------------------------------------------------------
    # add a function that called not_my_friends_with? with a parameter (friend_id)
    # look if i am already friends with him or not

  end

  def show
    # select the use that want you wan to view ans create a new template
    @user = User.find(params[:id])
    @user_stocks = @user.stocks
  end


end
