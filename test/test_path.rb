require 'minitest/autorun'
require 'lib/path'

class TestPath < Minitest::Unit::TestCase

  def test_get_url_path_should_be_use_the_full_url_to_be_unique
    url = 'http://sassass.github.io/assets/scss/main.scss'

    file_url_dir, folder_path, main_filename = url_parts(url)

    assert_equal 'sassass.github.io/assets/scss', folder_path 
    assert_equal 'main.scss', main_filename
    assert_equal 'http://sassass.github.io/assets/scss', file_url_dir
  end

end
