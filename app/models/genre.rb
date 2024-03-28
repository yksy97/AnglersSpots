class Genre < ApplicationRecord
  belongs_to :customer
  validates :name, uniqueness: { scope: :customer_id, case_sensitive: false },
                    presence: true,
                    length: { maximum: 50 }

  before_save :downcase_name

  # belongs_toの場合
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
# before_saveは、データベースに保存する前に実行されるコールバックで、downcase_nameはメソッド名です。
# downcase_nameメソッドは、name属性を小文字に変換し、文字列の前後にある空白を削除します。
# 「self」とは、現在のオブジェクト自身（操作しているモデルのインスタンスのname属性）を指します。
# privateをこのオブジェクトが保持しているデータとメソッドを外部から隠蔽するもの ＝ カプセル化
# 属性から値を読み出す場合、selfは省略可能です。しかし、Rubyでは属性への値の代入には原則としてselfを使用します。

# 属性とカラムの違い
# ざっくり説明すると、DB設計の段階ではnameは「カラム」で、そこからオブジェクト指向を用いた実際の開発段階に進むとカラムではなく「属性」と呼ぶ
# 属性とは、オブジェクト指向プログラミングにおいて、クラス（設計書）のインスタンス（実際の物）が持つ特性や状態を示すデータのこと。
# Rubyでは、ActiveRecordのようなORM（Object-Relational Mapping）を利用することで、データベースのカラムをクラスの属性として扱う。
# ORMを使用することで、データベースのカラムとオブジェクトの属性間で自動的にマッピングが行われる。すなわち、オブジェクト指向プログラミングでDBを操作できる。