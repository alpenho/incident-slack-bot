require './test/test_helper'

class IncidentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "is valid with valid attributes" do
    incident = Incident.new(title: "testing")
    assert incident.save
  end

  test "is not valid without a title" do
    incident = Incident.new
    assert_not incident.save
  end

  test "is valid with valid severity value" do
    incident = Incident.new(title: "testing", severity: "sev0")
    assert incident.save
  end

  test "should raise ArgumentError when severity value is not valid" do
    assert_raises(ArgumentError) do
      Incident.new(title: "testing", severity: "sev5")
    end
  end
end
