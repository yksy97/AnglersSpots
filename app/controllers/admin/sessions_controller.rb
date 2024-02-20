class Admin::SessionsController < Devise::SessionsController

def after_sign_in_path_for(resource)
  admin_customers_path
end

# ゲストログイン機能
  def guest_sign_in
    admin = Admin.guest
    sign_in admin
    redirect_to admin_customers_path, notice: "ゲスト管理者としてログインしました"
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
