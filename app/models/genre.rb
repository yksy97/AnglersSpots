class Genre < ApplicationRecord
  belongs_to :customer
  validates :name, uniqueness: { scope: :customer_id, case_sensitive: false },
                    presence: true,
                    length: { maximum: 50 }

  before_save :downcase_name

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  private

  def downcase_name
    self.name = name.strip.downcase
  end
end

# 勉強メモ
# ジャンル名が英字の場合
# before_saveは、データベースに保存する前に実行されるコールバックで、downcase_nameはメソッド名。
# downcase_nameメソッドは、name属性を小文字に変換し、文字列の前後にある空白を削除する。
# 「strip」で文字列の前後の空白を切り取り、「downcase」で大文字を小文字に変換する。
# 「self」とは、現在のオブジェクト自身（操作しているモデルのインスタンスのname属性）を指す。
# privateをこのオブジェクトが保持しているデータとメソッドを外部から隠蔽するもの ＝ カプセル化
# 属性から値を読み出す場合、selfは省略可能。しかし、Rubyでは属性への値の代入には原則としてselfを使用する。

# 属性とカラムの違い
# ざっくり説明すると、DB設計の段階ではnameは「カラム」で、そこからオブジェクト指向を用いた実際の開発段階に進むとカラムではなく「属性」と呼ぶ
# 属性とは、オブジェクト指向プログラミングにおいて、クラス（設計書）のインスタンス（実際の物）が持つ特性や状態を示すデータのこと。
# Rubyでは、ActiveRecordのようなORM（Object-Relational Mapping）を利用することで、データベースのカラムをクラスの属性として扱う。
# ORMを使用することで、データベースのカラムとオブジェクトの属性間で自動的にマッピングが行われる。すなわち、オブジェクト指向プログラミングでDBを操作できる。



# Ransack4の検索機能の導入が煩雑に感じるのは、セキュリティのため。
# ①「ransackable_attributes」メソッドで、検索可能な属性を制限している。　＝　属性を指定
# ②「ransackable_associations」メソッドで、どの関連付けを検索に使用できるか指定している。　＝　関連（例えば、他のモデルへのbelongs_to、has_many、has_oneなどの関連）を指定

# GenreモデルがCustomerモデルに従属(belongs_to)しているから「ransackable_attributes」メゾットを使うわけではないことに注意する。
# ransackable_attributesメソッドの使用は、モデルが他のモデルに従属しているかどうかとは関係なく、どの属性をユーザーに公開して検索可能にするか