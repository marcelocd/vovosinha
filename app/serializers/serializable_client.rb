class SerializableClient < JSONAPI::Serializable::Resource
  type 'clients'

  attributes :birthdate,
             :created_at,
             :deleted_at,
             :email,
             :first_name,
             :gender,
             :last_name,
             :main_phone_number,
             :second_phone_number,
             :updated_at

  belongs_to :account
  belongs_to :last_updated_by, class_name: 'User', optional: true
  belongs_to :deleted_by, class_name: 'User', optional: true

  has_many :service_orders
end