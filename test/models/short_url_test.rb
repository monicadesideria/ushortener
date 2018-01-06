# == Schema Information
#
# Table name: short_urls
#
#  id            :integer          not null, primary key
#  original_url  :string
#  is_custom_url :boolean          default(FALSE)
#  short_uid     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
