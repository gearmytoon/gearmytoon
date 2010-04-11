require 'test/test_helper'

class BetaParticipantTest < ActiveSupport::TestCase
  should_validate_presence_of :email
  should_validate_uniqueness_of :email, :case_sensitive => false
end
