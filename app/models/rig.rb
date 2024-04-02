class Rig < ApplicationRecord
  has_many :rig_posts, dependent: :destroy, foreign_key: 'rig_id'
  has_many :posts, through: :rig_posts

  # belongs_toの場合
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
  # has_manyの場合
  def self.ransackable_associations(auth_object = nil)
    ["posts", "rig_posts"]
  end
end



# Ransack検索機能のカスタマイズ
# 「ransackable_attributes」メソッドを定義して、検索可能な属性を制限する。例えば、Rigモデルでは「name」属性のみが検索対象。
# 「ransackable_associations」メソッドを定義して、検索可能な関連を指定する。Rigモデルの場合、「posts」と「rig_posts」関連が検索に使用できる。
# これにより、Rigの「name」属性に基づいた検索や、Rigに関連するPostやRigPostを通じた検索が可能になる。
# 検索条件のカスタマイズにより、アプリケーションのセキュリティと性能を向上させることができる。
# 例えば、 特定のユーザー権限に基づいて検索可能な属性や関連を動的に変更することも可能。
