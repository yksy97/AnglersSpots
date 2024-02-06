class Public::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters
  before_action :reject_customer, only: [:create]

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    customer_path(resource)
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(resource) }
        format.json { render json: { success: true, redirect_path: after_sign_in_path_for(resource) } }
      end
    else
      respond_to do |format|
        format.html { super }
        format.json { render json: { success: false, errors: ["ログインに失敗しました。メールアドレスまたはパスワードが正しくありません。"] }, status: :unauthorized }
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

  def reject_customer
    @customer = Customer.find_by(email: params[:customer][:email])

    if @customer && !@customer.valid_password?(params[:customer][:password])
      respond_to do |format|
        format.html { super }
        format.json { render json: { success: false, errors: ["退会済みです。または正しい登録情報を入力してください。"] }, status: :unauthorized }
      end
      return
    elsif !@customer
      respond_to do |format|
        format.html { super }
        format.json { render json: { success: false, errors: ["会員情報が見つかりません。再度会員登録をお願いします。"] }, status: :not_found }
      end
      return
    end
  end
end

