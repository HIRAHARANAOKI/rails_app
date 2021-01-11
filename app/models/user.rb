class User < ApplicationRecord
  before_save {self.email = email.downcase}
  # name属性の存在を確認
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  # ユーザーがセキュアなパスワードを持っている
  has_secure_password
  # セキュアなパスワードの完全な実装
  validates :password, presence: true, length: { minimum: 6}
end
