class MakePostgresRockEvenHarder < ActiveRecord::Migration[5.0]
  def change
    enable_extension :fuzzystrmatch
    enable_extension :pg_trgm
    enable_extension :unaccent
  end
end
