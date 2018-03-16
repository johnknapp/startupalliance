namespace :counters do

  # https://www.krautcomputing.com/blog/2015/01/13/recalculate-counter-cache-columns-in-rails/
  desc 'global counter_cache update'
  task reset_all: :environment do
    Rails.application.eager_load!
    ActiveRecord::Base.descendants.each do |many_class|
      many_class.reflections.each do |name, reflection|
        if reflection.options[:counter_cache]
          one_class = reflection.class_name.constantize
          one_table, many_table = [one_class, many_class].map(&:table_name)
          ids = one_class
          .joins(many_table.to_sym)
          .group("#{one_table}.id")
          .having("#{one_table}.#{many_table}_count != COUNT(#{many_table}.id)")
          .pluck("#{one_table}.id")
          ids.each do |id|
            one_class.reset_counters id, many_table
          end
        end
      end
    end
  end

  desc 'reset post reads'
  task reset_post_reads: :environment do
    Post.cleanup_read_marks!
  end

end