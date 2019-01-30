class AddInvoiceKeyToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :invoice_key, :string
  end
end
