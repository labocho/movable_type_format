$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require "movable_type_format"

# Build new entry
new_entry = MovableTypeFormat::Entry.new
new_entry.title = "New entry"
new_entry.body = "New entry's body"
comment = MovableTypeFormat::Section::Comment.new
comment.author = "Foo"
comment.body = "Comment body"
new_entry.comments = [comment]

# Export
puts new_entry.to_mt
