class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to:accountable,polymorphic:true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence:true , length: {minimum:5 , maximum:15}
  validates :contact , presence:true , length: {minimum:10 , maximum:10}, numericality: { only_integer: true, greater_than: 0 }
  

  def self.authenticate(email,password)
    account = Account.find_for_authentication(email:email)
    account&.valid_password?(password)? account : nil
  end
  
  

  has_many :access_tokens,
            class_name: 'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :delete_all
end
