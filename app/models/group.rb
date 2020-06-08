class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages
  validates :name, presence: true, uniqueness: true

  # 最新のメッセージを取得するメソッドを定義 => サイドバーのgroupに表示
  def show_last_message
    if (last_message = messages.last).present?
      if last_message.text?
        last_message.text
      else
        '画像が投稿されています'
      end
    else
      'まだメッセージはありません。'
    end
  end

end
