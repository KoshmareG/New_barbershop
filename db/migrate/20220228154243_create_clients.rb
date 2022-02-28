class CreateClients < ActiveRecord::Migration[7.0]
  def change
	create_table :client do |t|
		t.text :name
		t.text :phone
		t.text :datestamp
		t.text :color

		t.timestamp
	end
  end
end
