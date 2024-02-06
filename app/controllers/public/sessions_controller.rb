class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters
  before_action :reject_customer, only: [:create]

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
      if @customer.valid_password?(params[:customer][:password]) && !@customer.is_deleted
        flash[:notice] = "退会済みです。"
        redirect_to new_customer_registration_path
      else
        flash[:notice] = "正しい登録情報を入力してください。"
      end
    else
      flash[:notice] = "会員情報が見つかりません。再度会員登録をお願いします。"
    end
  end
end

