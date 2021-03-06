class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end

  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end

  def under_stock_limit?
    (user_stocks.count < 10)
  end

  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  # Define a function named search that can strip whitespaces and downcase the params[:search_param]
  # return a nil if id doesnt exist or return a variable
  def self.search(param)
    param.strip!
    param.downcase!
    User.where('first_name LIKE ?', "%#{param}%")
        .or(User.where('last_name LIKE ?', "%#{param}%"))
        .or(User.where('email LIKE ?', "%#{param}%"))
  end

  #a function that matches field name and param
  def self.matches(field_name, param)
    User.where("#{field_name} LIKE ?", "#{param}")
  end

  def except_current_user(users)
    users.reject {|user| user.id == self.id}
  end

  def not_my_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1

  end
end
