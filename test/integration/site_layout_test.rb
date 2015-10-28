require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest


  test "the truth" do
    assert true
  end


  test "top navigation bar links" do
    get home_path
    assert_template 'beta/index'

    assert_select "a[href=?]", home_path
    assert_select "a[href=?]", how_it_works_path
    #to do add map, community, sign up, login paths
    #to do: add paths to links on dropdown if user is logged in
  end


  test "footer links" do
    get home_path
    assert_template 'beta/index'

    #testing internal links
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", blog_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", policies_path
    assert_select "a[href=?]", privacy_path
    assert_select "a[href=?]", terms_path

    #testing social links
    assert_select "a[href=?]", 'https://www.facebook.com/gotriphappy'
    assert_select "a[href=?]", 'https://instagram.com/gotriphappy'
    assert_select "a[href=?]", 'http://twitter.com/gotriphappy'
  end

end
