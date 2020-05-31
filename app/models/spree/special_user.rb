module Spree
  class SpecialUser
    extend ActiveSupport::Concern  

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    # devise :database_authenticatable, :registerable,
           # :recoverable, :rememberable, :validatable
    has_many :spree_users
    # has_many :role_users, class_name: 'Spree::RoleUser', foreign_key: :user_id, dependent: :destroy
    # has_many :spree_roles, through: :role_users, class_name: 'Spree::Role', source: :role
  end
end