class CreateBarbers < ActiveRecord::Migration[7.0]
  def change
    create_table :barbers do |t|
      t.text :name
  
      t.timestamps
    end

    Barber.create :name => 'Георгий'
    Barber.create :name => 'Святослав'
    Barber.create :name => 'Матвей'
  end
end
