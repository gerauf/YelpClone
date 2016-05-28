class Restaurant < ActiveRecord::Base
  extend WithUserAssociationExtension

  belongs_to :user
  has_many :reviews,->{extending WithUserAssociationExtension},
           dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true

  has_attached_file :image, styles: {medium: "300x300>", thumb: "100x100>"},
                    default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def belongs_to? a_user
    user == a_user
  end

end
