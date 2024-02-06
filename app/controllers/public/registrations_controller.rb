class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 会員登録後の遷移先
  def after_sign_up_path_for(resource)
    customer_path(resource)
  end

  def create
    super do |resource|
      if request.xhr?
        if resource.persisted?
          # 登録成功(Ajax)
          render json: { status: 'success', location: after_sign_up_path_for(resource) } and return
        else
          # 登録失敗(Ajax)
          render json: { status: 'error', errors: resource.errors.full_messages }, status: :unprocessable_entity and return
        end
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
  end
end
