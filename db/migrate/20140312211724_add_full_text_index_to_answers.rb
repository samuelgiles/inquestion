class AddFullTextIndexToAnswers < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX answers_gin_content_idx ON answers USING GIN((to_tsvector(\'english\', coalesce("answers"."content"::text, \'\'))));'
  end

  def down
    execute "DROP INDEX answers_gin_content_idx;"
  end
end
