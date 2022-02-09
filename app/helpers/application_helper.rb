module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource
    @resource ||= User.new
  end
  
  def resource_name
    devise_mapping.name
  end
  
  def resource_class
    devise_mapping.to
  end

  def flash_method_class name
    {
      'alert'  => 'alert alert-warning alert-dismissible fade show',
      'notice' => 'alert alert-success alert-dismissible fade show'
    }[name]
  end

  def minimum_password_length
    User::MIN_PASSWORD_LENGTH
  end

  def locale_options
    [
      { language: 'english', code: 'en' },
      { language: 'portuguese', code: 'pt-BR' }
    ]
  end
end
