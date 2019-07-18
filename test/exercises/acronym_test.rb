require "test_helper"
require 'pry'

class AcronymTest < Minitest::Test
  def test_method_chaining_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end

  def test_method_chaining_with_block_syntax_passes_with_comment
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map { |word| word.chr }.join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal ["ruby.acronym.block_syntax.shorthand"], results[:comments]
  end

  def test_module_method_passes
    source = %q{
      module Acronym
        def self.abbreviate(words)
          words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end

  def test_refers_to_mentor_with_method_not_matching
    source = %q{
      class Acronym
        def self.abbreviate(words)
          test.words.tr('-', ' ').split.map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :refer_to_mentor, results[:status]
  end

  def test_refers_to_mentor_with_random_method_body
    source = %q{
      class Acronym
        def self.abbreviate(words)
          anything_here.123.456.test_method
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :refer_to_mentor, results[:status]
  end

  def test_scan_with_any_regex_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.scan(/any/).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end

  def test_split_with_any_regex_passes
    source = %q{
      class Acronym
        def self.abbreviate(words)
          words.split(/[ -]/).map(&:chr).join.upcase
        end
      end
    }
    results = Acronym::Analyze.(source)
    assert_equal :approve, results[:status]
    assert_equal [], results[:comments]
  end
end
