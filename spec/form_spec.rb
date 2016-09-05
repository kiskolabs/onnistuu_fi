require 'spec_helper'

describe OnnistuuFi::Form do
  let(:signer) { double("Signer") }
  let(:form_options) {
    {
      customer: "ad16ce80-a52b-47af-173b-15ef7914ca4a",
      return_failure: "http://example.com/failure",
      return_success: "http://example.com/success",
      document: "http://example.com/document",
      button: "<button type='submit'>Sign the document</button>",
      requirements: [
        {"type" => "person", "identifier" => "110761-635Y"}
      ]
    }
  }
  let(:form) { OnnistuuFi::Form.new(signer, form_options) }

  describe "#generate_html" do
    before do
      allow(signer).to receive(:encrypt).and_return(["IV", "ENCRYPTED_DATA"])
    end

    it "returns a form with correct url" do
      expect(form.generate_html).to have_tag("form", with: {action: "https://www.onnistuu.fi/external/entry/", method: "post"})
    end

    it "includes all required fields" do
      expect(form.generate_html).to have_tag("form") do
        with_tag "input", with: { name: "customer", type: "hidden", value: "ad16ce80-a52b-47af-173b-15ef7914ca4a" }
        with_tag "input", with: { name: "return_failure", type: "hidden", value: "http://example.com/failure" }
        with_tag "input", with: { name: "data", type: "hidden", value: "ENCRYPTED_DATA" }
        with_tag "input", with: { name: "iv", type: "hidden", value: "IV" }
        with_tag "input", with: { name: "padding", type: "hidden", value: "pkcs5" }
        with_tag "button", with: { type: "submit" }, text: "Sign the document"
      end
    end

    it "encrypts data using correct information" do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)

      expect(signer).to receive(:encrypt).with({
        stamp: now,
        return_success: "http://example.com/success",
        document: "http://example.com/document",
        requirements: [
          {"type" => "person", "identifier" => "110761-635Y"}
        ]
      })

      form.generate_html
    end
  end
end
