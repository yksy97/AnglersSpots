class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # ゲスト管理者用のメールアドレスを定数として設定
  GUEST_ADMIN_EMAIL = "guest_admin@example.com"

  # ゲスト管理者を見つけるか作成するメソッド
  def self.guest
    find_or_create_by!(email: GUEST_ADMIN_EMAIL) do |admin|
      # セキュアなランダムパスワードを生成
      admin.password = SecureRandom.urlsafe_base64
      # その他の必要な初期設定があればここに記述
    end
  end

  # ゲスト管理者かどうかを判定するメソッド
  def guest_admin?
    email == GUEST_ADMIN_EMAIL
  end
end
