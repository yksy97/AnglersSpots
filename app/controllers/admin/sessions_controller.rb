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
end