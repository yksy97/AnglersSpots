class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :reject_customer, only: [:create]

  # ゲストログイン機能
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to customer_path(customer), notice: "ゲストカスタマーとしてログインしました"
  end

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    customer_path(resource)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

  def reject_customer
    @customer = Customer.find_by(email: params[:customer][:email])
    if @customer
      if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted
        flash[:alert] = "退会済みです"
        redirect_to new_customer_session_path
      end
    end
  end
end
