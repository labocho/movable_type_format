$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/../lib")
require "movable_type_format"

mt = <<EOS
TITLE: A dummy title
BASENAME: a-dummy-title
AUTHOR: Foo Bar
DATE: 01/31/2002 03:31:05 PM
PRIMARY CATEGORY: Media
CATEGORY: News
-----
BODY:
This is the body.

Another paragraph here.

Another paragraph here.
-----
EXTENDED BODY:
Here is some more text.

Another paragraph here.

Another paragraph here.
-----
COMMENT:
AUTHOR: Foo
DATE: 01/31/2002 15:47:06
This is
the body of this comment.
-----
COMMENT:
AUTHOR: Bar
DATE: 02/01/2002 04:02:07 AM
IP: 205.66.1.32
EMAIL: me@bar.com
This is the body of
another comment. It goes
up to here.
-----
PING:
TITLE: My Entry
URL: http://www.foo.com/old/2002/08/
IP: 206.22.1.53
BLOG NAME: My Weblog
DATE: 08/05/2002 16:09:12
This is the start of my
entry, and here it...
-----
--------
TITLE: Here is a new entry
BASENAME: here-is-a-new-entry
AUTHOR: Baz Quux
DATE: 01/31/2002 03:31:05
CATEGORY: Politics
-----
BODY:
This is the body of the second entry. It can
consist of multiple lines.
-----
EXCERPT:
See, this entry does not have an extended piece; but
it does have an excerpt. It is special.
-----
COMMENT:
AUTHOR: Quux
URL: http://www.quux.com/
DATE: 01/31/2002 04:23:01 PM
Here is the first comment on this entry.
-----
--------
EOS

# Extract first entry
first_entry = MovableTypeFormat::Parser.parse(mt).to_a[0]
# Update ttitle
first_entry.title = "Updated title"
# Update comment
first_entry.comments[0].email = "dummy@example.com"
# Export
puts first_entry.to_mt
