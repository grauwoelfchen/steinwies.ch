require 'test_helper'

# /de/page/schwerputkte
class SchwerputkteTest < Minitest::Test
  include Steinwies::TestCase

  def setup
    browser.visit('/de/page/schwerpunkte')
  end

  def test_page_has_sub_titles
    assert_match('/de/page/schwerpunkte', browser.url)

    titles = browser.tds(class: 'subtitle').map(&:text)
    assert_equal('Schwerpunkte meiner Arbeit',                    titles[0])
    assert_equal('Berufliche Werkzeuge',                          titles[1])
    assert_equal('Zur Finanzierung von Beratungen und Therapien', titles[2])
  end
end
