class Genre < ApplicationRecord
has_many :posts
# 魚がもしアルファベットで入力された場合に、大文字と小文字の区別をなくす＝case_sensitive: false
  validates :name, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 50 }

  # ジャンル名を保存する前に小文字に変換し、前後の空白を削除
  before_save :downcase_name


  private

  # ジャンル名の前後の空白を削除し、アルファベットの場合は小文字に変換
  def downcase_name
    self.name = name.strip.downcase
  end
end