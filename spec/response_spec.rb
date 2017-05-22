require 'spec_helper'

describe OnnistuuFi::Response do
  it "decrypts the data" do
    signer = double(:signer)
    expect(signer).to receive(:decrypt).with("encrypted", "iv").and_return(JSON.load('{"stamp": "201012241200001234"}'))
    expect(OnnistuuFi::Response.new("encrypted", "iv", signer).data).to eq({"stamp" => "201012241200001234"})
  end
end
