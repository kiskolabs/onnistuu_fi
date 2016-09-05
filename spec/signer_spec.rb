require 'spec_helper'

describe OnnistuuFi::Signer do
  let(:signer) { OnnistuuFi::Signer.new("ad16ce80-a52b-47af-173b-15ef7914ca4a", "ADsqDFhic1wZYhHsN8mf6w99irb6jMcbGDYFpIqaF+E=") }

  it "decrypts what's encrypted" do
    iv, encrypted_data = signer.encrypt({"document" => "content"})
    expect(signer.decrypt(encrypted_data, iv)).to eq({"document" => "content"})
  end
end
