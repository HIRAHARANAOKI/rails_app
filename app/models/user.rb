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
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true

  class << self
  # 渡された文字列のハッシュ値を返す
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def new_token
    SecureRandom.urlsafe_base64
  end
  end
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = Usernew_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authnticated?(remember_token)
    return false if remember_digest.nil?
    BYrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attributte(:remember_digest, nil)
  end
end
