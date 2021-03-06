describe "papertrail" do
  it "by default, PaperTrail will be turned off" do
    expect(PaperTrail).to_not be_enabled
  end

  with_versioning do
    it "within a `with_versioning` block it will be turned on" do
      expect(PaperTrail).to be_enabled
    end
  end

  it "can be turned on at the `it` or `describe` level like this", versioning: true do
    expect(PaperTrail).to be_enabled
  end
end
