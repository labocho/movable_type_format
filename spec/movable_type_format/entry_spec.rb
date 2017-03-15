# encoding: UTF-8
require 'spec_helper'
require 'json'

module MovableTypeFormat
  describe Entry do
    it "to_mt" do
      e = Entry.new
      e.title = "Title"
      e.author = "Author"
      e.body = "Body\nBody"
      e.date = Time.new(2003, 6, 23, 23, 34, 22)
      e.sections << Section::Comment.new({author: "Comment Author"}, "Comment")

      expected = <<-MT
      TITLE: Title
      AUTHOR: Author
      DATE: 06/23/2003 23:34:22
      -----
      BODY:
      Body
      Body
      -----
      COMMENT:
      AUTHOR: Comment Author
      Comment
      -----
      --------
      MT
      expected.gsub!(/^\s+/, "")

      e.to_mt.should == expected
    end
    it "to_json" do
      e = Entry.new
      e.title = "Title"
      e.author = "Author"
      e.body = "Body\nBody"
      e.date = Time.utc(2003, 6, 23, 23, 34, 22)
      e.sections << Section::Comment.new({author: "Comment Author"}, "Comment")

      expected = "{\"body\":\"Body\\nBody\",\"author\":\"Author\",\"title\":\"Title\",\"date\":\"2003-06-23 23:34:22 UTC\",\"comments\":[{\"author\":\"Comment Author\",\"body\":\"Comment\"}]}"

      e.serialize.to_json.should == expected
    end
  end
end
