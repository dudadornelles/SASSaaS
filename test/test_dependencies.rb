require 'minitest/autorun'
require 'lib/dependencies'
require 'fileutils'

class TestDependencies < Minitest::Unit::TestCase
  ASSETS_TEST_PATH='/tmp/test-sassaas/assets/scss/'
  ASSETS_TEST_FOLDER='/tmp/test-sassaas-project'

  def setup
    FileUtils.mkdir_p(ASSETS_TEST_FOLDER)
    FileUtils.mkdir_p(ASSETS_TEST_PATH)
  end

  def teardown
    FileUtils.rm_rf(ASSETS_TEST_FOLDER)
    FileUtils.rm_rf(ASSETS_TEST_PATH)
  end

  def test_download_deps_of_does_it_recursively
    create_tmp_file('a.scss', ['b.scss', 'c.scss'])
    create_tmp_file('b.scss', ['d.scss'])
    create_tmp_file('c.scss')
    create_tmp_file('_d.scss')

    download_deps_of(ASSETS_TEST_PATH, 'a.scss', ASSETS_TEST_FOLDER)

    assert(File.exists?("#{ASSETS_TEST_FOLDER}/a.scss"))
    assert(File.exists?("#{ASSETS_TEST_FOLDER}/b.scss"))
    assert(File.exists?("#{ASSETS_TEST_FOLDER}/c.scss"))
    assert(File.exists?("#{ASSETS_TEST_FOLDER}/d.scss"))
  end

  private
  def create_tmp_file(name, imports=[])
    open("#{ASSETS_TEST_PATH}#{name}", 'w') do |f|
      f.puts imports.map {|dep| "@import \"#{dep}\"" }.join("\n")
      f.close
    end
  end

end

