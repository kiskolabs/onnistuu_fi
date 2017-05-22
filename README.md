# OnnistuuFi

This gem implements Onnistuu.fi API version 0.20.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'onnistuu_fi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install onnistuu_fi

## Dependencies

None.

## Usage

### Generating the form

```ruby
# Outputs the form HTML

OnnistuuFi.generate_form(
  client_identifier: ENV["ONNISTUU_FI_CLIENT_ID"],
  encryption_key: ENV["ONNISTUU_FI_ENCRYPTION_KEY"],
  fields: {
    return_failure: "https://example.com/failure",
    return_success: "https://example.com/success",
    document: "https://example.com/document.pdf",
    button_text: "Sign the document",
    requirements: [
      {"type": "person", "identifier": "110761-635Y"}
    ]
  }
)
```

If you want to customize the button & other form content, pass a block to `generate_form`:

```ruby
OnnistuuFi.generate_form(options) {
  "<button type="submit">Sign document</button>"
}
```

### Processing the response

```ruby

# Returns the data from Onnistuu.fi or raises OnnistuuFi::DecodeError

OnnistuuFi.decode_response(
  client_identifier: ENV["ONNISTUU_FI_CLIENT_ID"],
  encryption_key: ENV["ONNISTUU_FI_ENCRYPTION_KEY"],
  encrypted_data: params[:data],
  iv: params[:iv])
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

- A class for verifying a document

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kiskolabs/onnistuu_fi.

## License

The library is released under the MIT License.
