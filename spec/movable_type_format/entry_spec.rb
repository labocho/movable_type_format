# encoding: UTF-8
require 'spec_helper'

module MovableTypeFormat
  describe Entry do
    it "build" do
      e = Entry.new
      e.title = "Title"
      e.author = "Author"
      e.body = "Body\nBody"
      e.sections << Section::Comment.new({author: "Comment Author"}, "Comment")

      expected = <<-MT
      TITLE: Title
      AUTHOR: Author
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
  end
end
