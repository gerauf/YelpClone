class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews,->{extending WithUserAssociationExtension},
           dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true

  def belongs_to? a_user
    user == a_user
  end

end
