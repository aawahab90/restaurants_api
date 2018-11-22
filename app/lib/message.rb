class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.successfully_login
    'Account successfully login'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end

  def self.successfully_deleted(id, message)
    { status: { code: 0, id: id, message: message } }
  end

  def self.bad_request(errors)
    { status: { code: 1, message: errors } }
  end

  def self.warning(warning)
    { status: { code: 1, message: warning } }
  end

  def self.success(message)
    { status: { code: 0, message: message } }
  end
end