require 'spec_helper'

describe OnnistuuFi do
  it 'has a version number' do
    expect(OnnistuuFi::VERSION).not_to be nil
  end

  describe "generate_form" do
    let(:form_options) { {
      client_identifier: "ad16ce80-a52b-47af-a73b-25ef7914ca4a",
      encryption_key: "CDsqDFhicNwZYhHsN8mf6w99irb6jMcbGDYFpIqaF+E=",
      fields: {
        customer: "ad16ce80-a52b-47af-173b-15ef7914ca4a",
        return_failure: "http://example.com/failure",
        return_success: "http://example.com/success",
        document: "http://example.com/document",
        button_text: "Sign now",
        requirements: [
          {"type" => "person", "identifier" => "110761-635Y"}
        ]
      }
    } }
    let(:form) { OnnistuuFi.generate_form(form_options) }

    it "errors if client key and secret are not passed" do
      expect {
        OnnistuuFi.generate_form
      }.to raise_error(ArgumentError)

      expect {
        OnnistuuFi.generate_form(client_identifier: "ID")
      }.to raise_error(ArgumentError)
    end

    context "when passed a button text" do
      let(:form_options) { {
        client_identifier: "ad16ce80-a52b-47af-a73b-25ef7914ca4a",
        encryption_key: "CDsqDFhicNwZYhHsN8mf6w99irb6jMcbGDYFpIqaF+E=",
        fields: {
          return_failure: "http://example.com/failure",
          return_success: "http://example.com/success",
          document: "http://example.com/document",
          button_text: "MY CUSTOM TEXT",
          requirements: [
            {"type" => "person", "identifier" => "110761-635Y"}
          ]
        }
      } }

      it "create button with the text" do
        expect(form).to have_tag("form") do
          with_tag "button", with: { type: "submit" }, text: "MY CUSTOM TEXT"
        end
      end
    end

    context "when passed a block" do
      let(:form) { OnnistuuFi.generate_form(form_options) {
        "<span>No button</span>"
      } }

      it "runs the block and includes the return value to the form" do
        expect(form).to have_tag("form") do
          with_tag "span", text: "No button"
        end
      end
    end
  end

  describe "#decode_response" do
    context "when required parameters are missing" do
      it "raises argument error" do
        expect {
          OnnistuuFi.decode_response(
            encryption_key: "KEY"
          )
        }.to raise_error(ArgumentError)

        expect {
          OnnistuuFi.decode_response(
            client_identifier: "ID"
          )
        }.to raise_error(ArgumentError)
      end
    end

    context "when parameters are valid" do
      it "uses response object to decrypt it" do
        signer = double :signer, decrypt: "DECRYPTED"
        expect(OnnistuuFi::Signer).to receive(:new).with("ID", "KEY").and_return(signer)
        OnnistuuFi.decode_response(
          client_identifier: "ID",
          encryption_key: "KEY",
          encrypted_data: "DATA",
          iv: "IV"
        )
      end
    end
  end
end
