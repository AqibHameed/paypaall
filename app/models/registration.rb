class Registration < ActiveRecord::Base
  belongs_to :course
  before_create :set_key

  validates :full_name, :company, :email, :telephone, presence: true

  serialize :notification_params, Hash
  def paypal_url(return_path)
    values = {
        business: "#{ENV['paypal_business_account']}",
        cmd: "_xclick",
        upload: 1,
        return: "#{ENV['app_host']}#{return_path}",
        invoice: "#{self.invoice_key}",
        amount: course.price,
        item_name: course.name,
        item_number: course.id,
        quantity: '1',
        notify_url: "#{ENV['app_host']}/hook"
    }
    "#{ENV['paypal_host']}/cgi-bin/webscr?" + values.to_query
  end

  def set_key
    self.invoice_key = self.class.generate_unique_key unless invoice_key.present?
  end

  def self.generate_unique_key
    new_key = generate_key
    if exists?(invoice_key: new_key)
      generate_unique_key
    else
      new_key
    end
  end

  def self.generate_key
    letters = ('A'..'Z').to_a
    numbers = (1..9).to_a
    id = letters.sample(3) + numbers.sample(2) + letters.sample(1)
    id.join('')
  end

end
