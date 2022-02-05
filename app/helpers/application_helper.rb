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
end
