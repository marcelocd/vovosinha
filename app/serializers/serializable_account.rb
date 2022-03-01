class SerializableAccount < JSONAPI::Serializable::Resource
  type 'accounts'

  attributes :company_name

  belongs_to :owned_by, class_name: 'User'
  belongs_to :last_updated_by, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true

  has_many :users
end