class TackleItem < ApplicationRecord
end

# TackleItemモデルが空なのは、単純にタックルのアイテムのname属性を持つだけなので、条件定義（バリデーションなど）やデータ加工を必要としてないから。



# TackleItemのMigrateファイルのt.integer :orderについて
# このorder属性は、「ルアー」や「ロッド」といった具体的な釣具の項目とその順番を表すため。
# -表示する順番の条件は、seedファイルに記述する。
# tackle_items = [
  # {name: 'ロッド', order: 10},
  # {name: 'リール', order: 20},
  # {name: 'ライン', order: 30},
  # {name: 'リーダー', order: 40},
  # {name: 'ルアー', order: 50},
  # {name: '針', order: 60},
  # {name: 'ウキ', order: 70},
  # {name: 'その他', order: 9999}
# ]

# UIでは、数字が少ない項目から順番に表示される。

# tackle_items.each do |ti|
#   TackleItem.find_or_create_by(name: ti[:name]) do |i|
#     i.order = ti[:order]
#   end
# end

# Railsの「find_or_create_by」メソッドを使って、登録された項目をTackleItemモデルから登録された項目が存在しないか確認して、存在しない場合は新しい項目として登録する。

# 「name: ti[:name]」は、ハッシュ構文で、TackleItemモデルのname属性とtackle_items配列の各要素に含まれるname値が一致するという意味
# 「tackle_items配列の各要素に含まれるname値」とは、まだデータベースに登録されていない可能性があるタックルの項目のこと。＝この段階では、シードデータとして定義されている。

# 「i.order = ti[:order]」
# 新しく追加された項目は、「i.order = ti[:order]」によって、order値が70から9999の間に指定されて、「ウキ」以降に追加される。

