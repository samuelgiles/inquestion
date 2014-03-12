class AddFullTextIndexes < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX questions_gin_title_and_content_idx ON questions USING GIN((to_tsvector(\'english\', coalesce("questions"."title"::text, \'\'))  || to_tsvector(\'english\', coalesce("questions"."content"::text, \'\')) ));'
  end

  def down
    execute "DROP INDEX questions_gin_title_and_content_idx;"
  end
end
