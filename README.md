#  movable_type_format

Movable Type import / export format parser and builder for Ruby.

Format documentation is below.

* http://www.movabletype.org/documentation/appendices/import-export-format.html
* http://www.movabletype.jp/documentation/appendices/import-export-format.html

# Installation

    $ git clone https:://github.com/labocho/movable_type_format.git
    $ cd movable_type_format
    $ bundle install
    $ bundle exec rake install

# Usage

## Parse

First, load gem.

    require "movable_type_format"

`MovableTypeFormat::Parser.parse` parses `String` or `IO`, and returns `Enumerator` of `MovableTypeFormat::Entry`.

    exported = File.read("exported.txt")
    entries = MovableTypeFormat::Parser.parse(exported)

`MovableTypeFormat::Entry` has sections. Sections are collection of `MovableTypeFormat::Section::Base` (or its descendant).

    entry = entries.to_a[0]
    pp entry.sections
    # [#<MovableTypeFormat::Section::Metadata:0x007fc3f39b2238
    #   @body=nil,
    #   @fields=
    #    [#<MovableTypeFormat::Field:0x007fc3f39b1f18
    #      @key="TITLE",
    #      @value="A dummy title">,
    # ...

`MovableTypeFormat::Section::Base` has `name`, `fields`, and `body`. Field has `key` and `value`.

    comment = entry.sections.find{|s| s.name == "COMMENT" }
    comment.name #=> "COMMENT"
    comment.fields
    # [#<MovableTypeFormat::Field:0x007fc3f39a32d8 @key="AUTHOR", @value="Foo">,
    #   #<MovableTypeFormat::Field:0x007fc3f39a3120
    #    @key="DATE",
    #    @value="01/31/2002 15:47:06">]
    comment.body #=> "This is\nthe body of this comment."

## Usable accessors

`MovableTypeFormat::Entry` has usable accessors of sections. (Some accessors access metadata section.)

    # Available accessors:
    #   allow_comments, allow_pings, author, basename, body,
    #   category, convert_breaks, date, excerpt, extended_body,
    #   keywords, no_entry, primary_category, status, tags, title
    p entry.title #=> "A dummy title"
    entry.title = "Updated title"

    # comments, pings are collections of sections.
    p entry.comments[0].title #=> "Comment title"
    entry.comments = entry.comments.reject{|c| c.title["SPAM"] }

`MovableTypeFormat::Section::Comment` has usable accessors of fields.

    # Available accessors:
    #   author, date, email, url
    comment = MovableTypeFormat::Section::Comment.new
    comment.author = "labocho"
    comment.body = "Comment body"

`MovableTypeFormat::Section::Metadata` has usable accessors of fields.

    # Available accessors:
    #   author, title, basename, status, allow_comments, allow_pings,
    #   convert_breaks, primary_category, category, date, tags, no_entry
    metadata = MovableTypeFormat::Section::Metadata.new
    metadata.title = "Title"

`MovableTypeFormat::Section::Ping` has usable accessors of fields.

    # Available accessors:
    #   title, url, ip, blog_name, date
    ping = MovableTypeFormat::Section::Ping.new
    ping.title = "New ping"

## Export

`MovableTypeFormat::Entry#to_mt` returns MovableType export format string.

    entry.to_mt
    # TITLE: Updated title
    # AUTHOR: Foo Bar
    # ...

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/movable_type_format.


# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

