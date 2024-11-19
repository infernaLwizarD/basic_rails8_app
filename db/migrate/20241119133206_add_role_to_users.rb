class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL.squish
      CREATE TYPE user_role AS ENUM ('admin', 'user');
    SQL
    add_column :users, :role, :user_role
  end

  def down
    remove_column :users, :role
    execute <<~SQL.squish
      DROP TYPE user_role;
    SQL
  end
end
